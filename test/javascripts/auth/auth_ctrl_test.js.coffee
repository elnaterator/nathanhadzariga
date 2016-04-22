describe 'AuthCtrl', () ->

  $httpBackend = null
  $scope = null
  User = null
  AuthSrvc = null
  $location = null
  beforeEach(() ->
    module('natesApp.auth')
    inject( ($controller, _$httpBackend_, _User_, _AuthSrvc_, _$location_) ->
      $scope = {}
      $controller('AuthCtrl', { $scope : $scope })
      $httpBackend = _$httpBackend_
      User = _User_
      AuthSrvc = _AuthSrvc_
      $location = _$location_
    )
  )

  afterEach( () ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
  )

  describe '#login', () ->

    describe 'with success', () ->

      beforeEach( () ->
        $scope.user.email = 'test@email.com'
        $scope.user.password = 'password'
        $httpBackend.expect('POST', '/users/login', { email: 'test@email.com', password: 'password'})
          .respond(200, { id: 123, name: 'Henry', email: 'test@email.com' }, {access_token: 'someToken'})
        spyOn($location, 'path')
        $scope.login()
        $httpBackend.flush()
      )

      it 'should log in user and set token', () ->
        # current user should be stored
        expect(User.getCurrent().id).toBe(123)
        expect(User.getCurrent().name).toBe('Henry')
        # token should be stored
        expect(AuthSrvc.getToken()).toBe('someToken')

      it 'should put user info on scope', () ->
        expect($scope.user.id).toBe(123)
        expect($scope.user.name).toBe('Henry')

      it 'should nav user to home page', () ->
        expect($location.path).toHaveBeenCalledWith('/')

    describe 'with auth err', () ->

      beforeEach( () ->
        $scope.user.email = 'test@email.com'
        $scope.user.password = 'password'
        $httpBackend.expect('POST', '/users/login', { email: 'test@email.com', password: 'password'}).respond(401, '')
        spyOn($location, 'path')
        $scope.login()
        $httpBackend.flush()
      )

      it 'should put error message on scope', () ->
        expect($scope.errors[0]).toBe('Invalid email or password.')

      it 'should not nav anywhere', () ->
        expect($location.path).not.toHaveBeenCalled()


  describe '#toggleNewUser', () ->

    it 'should be toggleable boolean property', () ->
      expect($scope.isNewUser).toBe(false)
      $scope.toggleNewUser()
      expect($scope.isNewUser).toBe(true)
      $scope.toggleNewUser()
      expect($scope.isNewUser).toBe(false)

  describe '#signup', () ->

    describe 'with success response', () ->

      beforeEach( () ->
        $scope.user.name = 'Bill Billson'
        $scope.user.email = 'test@email.com'
        $scope.user.password = 'password'
        $scope.user.password_confirmation = 'password'
        $httpBackend.expect('POST', '/users/signup',
          {name: 'Bill Billson', email: 'test@email.com', password: 'password', password_confirmation: 'password'})
        .respond(200, {id: 123, name: 'Bill Billson', email: 'test@email.com'}, {access_token: 'someToken'})
        spyOn($location, 'path')
        $scope.signup()
        $httpBackend.flush()
      )

      it 'should log new user in', () ->
        expect(User.getCurrent().id).toBe(123)
        expect(AuthSrvc.getToken()).toBe('someToken')
