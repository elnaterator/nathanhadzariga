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
        .respond(200,[{id:123,title:'Post1',body:'Body'},{id:456,title:'Post2',body:'Body'}])
      $controller('BlogMgmtCtrl', {$scope:$scope})
      $httpBackend.flush()
    )

    describe 'adding a new post', () ->

      it 'should put new empty post on scope', () ->
        expect($scope.post()).toBeDefined()
        expect($scope.post() instanceof Post).toBe(true)
        expect($scope.post().id).toBeUndefined()
        expect($scope.post().title).toBeUndefined()

      it 'should create a new post, add it to list, and reset post on scope', () ->
        $httpBackend.expect('POST', '/posts', {title:'New Post',body:'Body'})
          .respond(200,{id:123,title:'New Post',body:'Body'})
        $scope.post().title = 'New Post'
        $scope.post().body = 'Body'
        $scope.create()
        $httpBackend.flush()
        expect($scope.posts().length).toBe(3)
        expect($scope.post().title).toBeUndefined()

      it 'should put errors on scope and leave post as is', () ->
        $httpBackend.expect('POST', '/posts', {title:'New Post',body:'Body'})
          .respond(422,{title:['is invalid'],body:['is missing','is invalid']})
        $scope.post().title = 'New Post'
        $scope.post().body = 'Body'
        $scope.create()
        $httpBackend.flush()
        expect($scope.post().title).toBe('New Post')
        expect($scope.errors().length).toBe(2)

    describe 'editing a post', () ->

      it 'should put editMode on scope', () ->
        expect($scope.editMode()).toBe(false)
        $scope.editMode(true)
        expect($scope.editMode()).toBe(true)
        $scope.editMode(false)
        expect($scope.editMode()).toBe(false)

      it 'should set a post up for editing', () ->
        expect($scope.editMode()).toBe(false)
        $scope.edit(456)
        expect($scope.post().id).toBe(456)
        expect($scope.post().title).toBe('Post2')
        expect($scope.editMode()).toBe(true)

      it 'should cancel an edit', () ->
        $scope.edit(456)
        $scope.post().title = 'Updated'
        $scope.post().body = 'Updated'
        $scope.editMode(false) # cancel edit
        expect($scope.post().title).toBe('Post2')
        expect($scope.post().body).toBe('Body')
        expect($scope.editMode()).toBe(false)

      it 'should update a post and reset scope on success', () ->
        $httpBackend.expect('PATCH','/posts/123',{id:123,title:'Post1',body:'Updated'})
          .respond(200,{id:123,title:'Post1',body:'Updated'})
        $scope.edit(123)
        $scope.post().body = 'Updated'
        $scope.update()
        $httpBackend.flush()
        expect($scope.post().id).toBeUndefined()
        expect($scope.post().title).toBeUndefined()
        expect($scope.editMode()).toBe(false)

      it 'should put errors on scope and leave editMode and post as is', () ->
        $httpBackend.expect('PATCH','/posts/123',{id:123,title:'Post1',body:'Updated'})
          .respond(422,{title:['is invalid'],body:['is missing','is invalid']})
        $scope.edit(123)
        $scope.post().body = 'Updated'
        $scope.update()
        $httpBackend.flush()
        expect($scope.post().id).toBe(123)
        expect($scope.post().title).toBe('Post1')
        expect($scope.editMode()).toBe(true)
        expect($scope.errors().length).toBe(2)

    describe 'deleting a post', () ->

      it 'should delete a post', () ->
        $httpBackend.expect('DELETE','/posts/456').respond(200,'')
        $scope.delete(456)
        $httpBackend.flush()
        expect($scope.posts().length).toBe(1)

      it 'should put errors on scope', () ->
        $httpBackend.expect('DELETE','/posts/456').respond(400,'')
        $scope.delete(456)
        $httpBackend.flush()
        expect($scope.posts().length).toBe(2)
        expect($scope.errors().length).toBe(1)
