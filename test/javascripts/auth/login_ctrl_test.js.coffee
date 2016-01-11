describe 'LoginCtrl', () ->

  $httpBackend = null
  $scope = null
  User = null
  AuthSrvc = null
  beforeEach(() ->
    module('natesApp.auth')
    inject( ($controller, _$httpBackend_, _User_, _AuthSrvc_) ->
      $scope = {}
      $controller('LoginCtrl', { $scope : $scope })
      $httpBackend = _$httpBackend_
      User = _User_
      AuthSrvc = _AuthSrvc_
    )
  )

  afterEach( () ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
  )

  describe '#login', () ->

    it 'should log user in', () ->
      $httpBackend.expect('POST', '/users/login', { email: 'test@email.com', password: 'password'})
        .respond(200, { id: 123, name: 'Henry', email: 'test@email.com' }, {access_token: 'someToken'})
      $scope.user.email = 'test@email.com'
      $scope.user.password = 'password'
      $scope.login()
      $httpBackend.flush()
      # current user should be stored
      expect(User.getCurrent().id).toBe(123)
      expect(User.getCurrent().name).toBe('Henry')
      # user name should now be on scope
      expect($scope.user.name).toBe('Henry')
      # token should be stored
      expect(AuthSrvc.getToken()).toBe('someToken')
