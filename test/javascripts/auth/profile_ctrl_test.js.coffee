describe 'ProfileCtrl', () ->

  User = null
  $scope = {}
  $httpBackend = null
  $location = null

  beforeEach( () ->
    $scope = {}
    module('natesApp.auth')
    inject( ($controller, _User_, _$httpBackend_, _$location_) ->
      User = _User_
      $controller('ProfileCtrl', { $scope: $scope })
      $httpBackend = _$httpBackend_
      $location = _$location_
    )
  )

  beforeEach( () ->
    User.setCurrent(new User({ id: 123, name: 'Henry' }))
  )

  afterEach( () ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
  )

  it 'should put currently logged in user on scope', () ->
    expect($scope.user()).toBeDefined()
    expect($scope.user().name).toBe('Henry')

  describe 'deleting account', () ->

    it 'should be able to toggle deleteConfirm, default false', () ->
      expect($scope.confirmDeleteMode()).toBe(false)
      $scope.confirmDeleteMode(true)
      expect($scope.confirmDeleteMode()).toBe(true)
      $scope.confirmDeleteMode(false)
      expect($scope.confirmDeleteMode()).toBe(false)

    it 'should send request to delete user and logout', () ->
      $httpBackend.expect('DELETE', '/users/123').respond(200, '')
      spyOn($location, 'path')
      $scope.delete()
      $httpBackend.flush()
      expect(User.getCurrent()).toBeNull()
      expect($location.path).toHaveBeenCalledWith('/')

  describe 'editing user information', () ->

    it 'should allow user to toggle editMode, default false', () ->
      expect($scope.editMode()).toBe(false)
      $scope.editMode(true)
      expect($scope.editMode()).toBe(true)
      $scope.editMode(false)
      expect($scope.editMode()).toBe(false)

    it 'should reset user edits when edit cancelled', () ->
      $scope.editMode(true)
      $scope.user().name = 'George'
      $scope.editMode(false)
      expect($scope.user().name).toBe('Henry')

    it 'should update user with changes made', () ->
      $scope.editMode(true)
      $scope.user().name = 'George'
      $httpBackend.expect('PATCH', '/users/123', {id: 123,name:'George'})
        .respond(200, {id:123,name:'George',email:'email@email.com'})
      $scope.updateUser()
      $httpBackend.flush()
      expect($scope.user().name).toBe('George')
      expect($scope.user().email).toBe('email@email.com')

    it 'should show errors for failed updates', () ->
      $scope.editMode(true)
      $scope.user().email = 'invalid'
      $httpBackend.expect('PATCH','/users/123',{id:123,name:'Henry',email:'invalid'})
        .respond(422,{email:['is invalid']})
      $scope.updateUser()
      $httpBackend.flush()
      expect($scope.errors().length).toBe(1)
      expect($scope.errors()[0]).toBe('Email is invalid.')
      expect($scope.editMode()).toBe(true)
      expect($scope.user().email).toBe('invalid')
