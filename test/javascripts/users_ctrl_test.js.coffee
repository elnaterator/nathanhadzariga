describe 'UsersCtrl', () ->
  beforeEach(module('homeApp'))

  $httpBackend = null
  $controller = null
  $scope = null
  ctrl = null

  beforeEach( inject( (_$httpBackend_, _$controller_) ->
    $httpBackend = _$httpBackend_
    $controller = _$controller_
    $scope = {}
    ctrl = $controller('UsersCtrl', { $scope : $scope })
  ))

  afterEach( () ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
  )

  it 'fetches list of users', () ->
    $httpBackend.expect('GET', '/users').respond([{"id":123, "name":"Bill", "email":"bill@email.com"}])
    expect($scope.users.length).toBe(0)
    $scope.fetchUsers()
    $httpBackend.flush()
    expect($scope.users.length).toBe(1)
    expect($scope.users[0].id).toBe(123)

  it 'creates a user', () ->
    $scope.user.name = 'Bill'
    $scope.user.email = 'bill@email.com'
    $scope.user.password = 'password'
    $scope.user.password_confirmation = 'password'
    $httpBackend.expect('POST', '/users',
      {name: 'Bill', email: 'bill@email.com', password: 'password', password_confirmation: 'password'})
      .respond({"id":123, "name":"Bill", "email":"bill@email.com"})
    expect($scope.users.length).toBe(0)
    $scope.createUser()
    $httpBackend.flush()
    # should add user to list
    expect($scope.users.length).toBe(1)
    expect($scope.users[0].id).toBe(123)
    # should clean up newUser model
    expect($scope.user.name).toBeUndefined()
    expect($scope.user.email).toBeUndefined()

  it 'deletes a user', () ->
    # start with a user
    $scope.users.push({"id":123, "name":"Bill", "email":"bill@email.com"})
    expect($scope.users.length).toBe(1)
    # then delete
    $httpBackend.expect('DELETE', '/users/123').respond({})
    $scope.deleteUser(123)
    $httpBackend.flush()
    expect($scope.users.length).toBe(0)

  it 'updates a user', () ->
    # start with a user
    $scope.editMode = true
    $scope.user.id = 123
    $scope.user.name = 'Billard'
    $scope.user.email = 'bill@email.com'
    $httpBackend.expect('PATCH', '/users/123', {id: 123, name: 'Billard', email: 'bill@email.com'})
      .respond({"id":123, "name":"Billard", "email":"bill@email.com"})
    $scope.updateUser()
    $httpBackend.flush()
    expect($scope.user.id).toBeUndefined()
    expect($scope.user.name).toBeUndefined()
    expect($scope.user.email).toBeUndefined()
    expect($scope.editMode).toBe(false)

  it 'sets up editing of a user', () ->
    $scope.users = [{id:123,name:'Bill',email:'bill@bill.com'},{id:456,name:'Joe',email:'joe@jope.com'}]
    $scope.editMode = false
    $scope.user = {}
    $scope.editUser(123)
    expect($scope.editMode).toBe(true)
    expect($scope.user.name).toBe('Bill')
    expect($scope.user.email).toBe('bill@bill.com')

  it 'cancels editing of a user', () ->
    $scope.editMode = true
    $scope.user = {id:123,name:'Bill',email:'bill@bill.com'}
    $scope.cancelEdit()
    expect($scope.editMode).toBe(false)
    expect($scope.user.id).toBeUndefined()
    expect($scope.user.name).toBeUndefined()
    expect($scope.user.email).toBeUndefined()
