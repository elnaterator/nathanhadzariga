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

  it 'should put currently logged in user on scope', () ->
    User.setCurrent(new User({ name: 'Henry' }))
    expect($scope.user()).toBeDefined()
    expect($scope.user().name).toBe('Henry')

  describe 'toggle delete confirm', () ->

    it 'should toggle deleteConfirm', () ->
      $scope.deleteConfirm = false
      $scope.toggleDeleteConfirm()
      expect($scope.deleteConfirm).toBe(true)
      $scope.toggleDeleteConfirm()
      expect($scope.deleteConfirm).toBe(false)

  describe 'delete account button', () ->

    beforeEach( () ->
      User.setCurrent(new User({ id: 123, name: 'Henry' }))
    )

    afterEach( () ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()
    )

    it 'should send request to delete user and logout', () ->
      $httpBackend.expect('DELETE', '/users/123').respond(200, '')
      spyOn($location, 'path')
      $scope.delete()
      $httpBackend.flush()
      expect(User.getCurrent()).toBeNull()
      expect($location.path).toHaveBeenCalledWith('/')
