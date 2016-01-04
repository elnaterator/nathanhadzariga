describe 'UserCtrl', () ->
  beforeEach(module('homeApp'))

  $httpBackend = null
  $controller = null
  $scope = null
  ctrl = null

  beforeEach( inject( (_$httpBackend_, _$controller_) ->
    $httpBackend = _$httpBackend_
    $controller = _$controller_
    $scope = {}
    ctrl = $controller('UserCtrl', { $scope : $scope })
  ))

  afterEach( () ->
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest();
  )

  it 'fetches a list of users', () ->
    $httpBackend.expect('GET', '/users').respond([{"id":123, "name":"Bill", "email":"bill@email.com"}])
    expect($scope.users.length).toBe(0)
    $scope.fetchUsers()
    $httpBackend.flush()
    expect($scope.users.length).toBe(1)
    expect($scope.users[0].id).toBe(123)
