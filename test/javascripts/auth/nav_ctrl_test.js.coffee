describe 'NavCtrl', () ->

  $scope = null
  $location = null
  AuthSrvc = null
  User = null

  beforeEach( () ->
    module('natesApp.auth')
    $scope = {}
    inject(($controller, _$location_, _AuthSrvc_, _User_) ->
      $controller('NavCtrl', {$scope: $scope})
      $location = _$location_
      AuthSrvc = _AuthSrvc_
      User = _User_
    )
  )

  describe '#isLoggedIn', () ->

    it 'should return true if we have a valid token', () ->
      AuthSrvc.setToken('someToken')
      expect($scope.isLoggedIn()).toBe(true)

    it 'should return false if we dont have a token', () ->
      expect($scope.isLoggedIn()).toBe(false)
      AuthSrvc.setToken(null)
      expect($scope.isLoggedIn()).toBe(false)
      AuthSrvc.setToken(undefined)
      expect($scope.isLoggedIn()).toBe(false)

  describe '#getUser', () ->

    it 'should return current logged in user', () ->
      User.setCurrent(undefined)
      expect($scope.getUser()).toBeUndefined()
      User.setCurrent(new User({name: 'Billy'}))
      expect($scope.getUser().name).toBe('Billy')

  describe '#logout', () ->

    beforeEach( () ->
      # log user in
      User.setCurrent( new User({name: 'Henry'}) )
      AuthSrvc.setToken('someToken')
      spyOn($location, 'path')
      # logout
      $scope.logout()
    )

    it 'should delete access token', () ->
      expect(AuthSrvc.getToken()).toBeNull()

    it 'should delete current user', () ->
      expect(User.getCurrent()).toBeNull()

    it 'should nav to home page', () ->
      expect($location.path).toHaveBeenCalledWith('/')
