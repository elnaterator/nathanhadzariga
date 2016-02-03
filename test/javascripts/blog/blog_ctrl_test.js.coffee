describe 'BlogCtrl', () ->

  $httpBackend = null
  $controller = null
  $scope = null

  beforeEach(() ->
    module('natesApp.blog')
    inject( (_$controller_, _$httpBackend_) ->
      $scope = {}
      $controller = _$controller_
      $httpBackend = _$httpBackend_
    )
  )

  afterEach( () ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
  )

  it 'should retrieve posts on initialization', () ->
    $httpBackend.expect('GET', '/posts')
      .respond(200, [{title:'Post 1',body:'First post.'},{title:'Post 2',body:'Second post.'}])
    $controller('BlogCtrl', { $scope : $scope })
    $httpBackend.flush()
    expect($scope.posts().length).toBe(2)
