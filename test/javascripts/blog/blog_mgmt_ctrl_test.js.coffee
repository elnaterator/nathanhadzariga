describe 'BlogMgmtCtrl', () ->

  $httpBackend = null
  $controller = null
  $scope = null
  Post = null

  beforeEach(() ->
    module('natesApp.blog')
    inject( (_$controller_, _$httpBackend_, _Post_) ->
      $scope = {}
      $controller = _$controller_
      $httpBackend = _$httpBackend_
      Post = _Post_
    )
  )

  afterEach( () ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
  )

  it 'should retrieve list of posts on instantiation', () ->
    $httpBackend.expect('GET', '/posts')
      .respond(200,[{title:'Post1'},{title:'Post2'}])
    $controller('BlogMgmtCtrl', {$scope:$scope})
    $httpBackend.flush()
    expect($scope.posts().length).toBe(2)

  describe 'instantiated', () ->

    beforeEach( () ->
      $httpBackend.expect('GET', '/posts')
        .respond(200,[{id:123,title:'Post1'},{id:456,title:'Post2'}])
      $controller('BlogMgmtCtrl', {$scope:$scope})
      $httpBackend.flush()
    )

    describe 'adding new posts', () ->

      it 'should put individual post on scope', () ->
        expect($scope.post()).toBeDefined()
        expect($scope.post() instanceof Post).toBe(true)

      it 'should create a new post, add it to list, and reset post on scope', () ->
        $httpBackend.expect('POST', '/posts', {title:'New Post',body:'Body'})
          .respond(200,{id:123,title:'New Post',body:'Body'})
        $scope.post().title = 'New Post'
        $scope.post().body = 'Body'
        $scope.create()
        $httpBackend.flush()
        expect($scope.posts().length).toBe(3)
        expect($scope.post().title).toBeUndefined()

    describe 'editing a post', () ->

      it 'should be able to toggle edit mode', () ->
        expect($scope.editMode()).toBe(false)
        $scope.editMode(true)
        expect($scope.editMode()).toBe(true)
        $scope.editMode(false)
        expect($scope.editMode()).toBe(false)

      it 'should allow setting a post for editing', () ->
        $scope.edit(456)
        expect($scope.post().id).toBe(456)
        expect($scope.post().title).toBe('Post2')
        expect($scope.editMode()).toBe(true)
