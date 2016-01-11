describe 'LoginCtrl', () ->

  $httpBackend = null
  $scope = null
  beforeEach(() ->
    module('natesApp.auth')
    inject( ($controller, _$httpBackend_) ->
      $scope = {}
      $controller('LoginCtrl', { $scope : $scope })
      $httpBackend = _$httpBackend_
    )
  )

  afterEach( () ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
  )

  describe '#login', () ->

    xit 'sends valid email / password to login endpoint', () ->
      $httpBackend.expect('POST', '/users/login', { email: 'test@email.com', password: 'password'})
        .respond(200, { id: 123, name: 'Henry', email: 'test@email.com' })
      $scope.login()
      $httpBackend.flush()
