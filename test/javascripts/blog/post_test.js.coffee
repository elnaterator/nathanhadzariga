describe 'Post', () ->

  $httpBackend = null
  Post = null

  beforeEach(() ->
    module('natesApp.blog')
    inject( (_$httpBackend_, _Post_) ->
      $httpBackend = _$httpBackend_
      Post = _Post_
    )
  )

  it 'should be resource with operations query and get', () ->
    expect(Post).toBeDefined()
    expect(Post.query).toBeDefined()
    expect(Post.get).toBeDefined()
    post = new Post
    expect(post.$query).toBeDefined()
    expect(post.$get).toBeDefined()


  describe 'basic CRUD operations', () ->

    it 'should retrieve all posts with query', () ->
      $httpBackend.expect('GET','/posts')
        .respond(200, [{title:'Post1'},{title:'Post2'}])
      posts = Post.query()
      $httpBackend.flush()
      expect(posts.length).toBe(2)
      expect(posts[0] instanceof Post).toBeTruthy()
      expect(posts[0].title).toBe('Post1')

    it 'should retrieve single post with get', () ->
      $httpBackend.expect('GET','/posts/123')
        .respond(200, {title:'Post1'})
      post = Post.get({id:123})
      $httpBackend.flush()
      expect(post.title).toBe('Post1')

    it 'should create new post with save', () ->
      $httpBackend.expect('POST','/posts',{title:'Title',body:'Body'})
        .respond(200,{id:123,title:'Title',body:'Body'})
      post = new Post({title:'Title',body:'Body'})
      post.$save()
      $httpBackend.flush()

    it 'should update post with update', () ->
      $httpBackend.expect('PATCH','/posts/123',{id:123,title:'Title',body:'Body'})
        .respond(200,{id:123,title:'Title',body:'Body'})
      post = new Post({id:123,title:'Title',body:'Body'})
      post.$update()
      $httpBackend.flush()

    it 'should delete post with delete', () ->
      $httpBackend.expect('DELETE','/posts/123').respond(200,'')
      post = new Post({id:123})
      post.$delete()
      $httpBackend.flush()
