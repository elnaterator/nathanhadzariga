angular.module('natesApp.blog')

.controller('BlogMgmtCtrl', ['$scope', 'Post', 'ErrSrvc', ($scope, Post, ErrSrvc) ->

  posts = []
  post = new Post
  editMode = false
  cachedPostProps = null
  errors = []

  $scope.posts = () ->
    posts

  $scope.post = () ->
    post

  $scope.errors = () ->
    errors

  $scope.editMode = (em) ->
    if em != undefined
      if em
        editMode = true
      else
        editMode = false
        for k,v of cachedPostProps
          post[k] = v
    editMode

  $scope.edit = (id) ->
    i = _.findIndex(posts,['id',id])
    post = posts[i]
    editMode = true
    cachedPostProps = _.pick(post,['title','body'])

  # persistence

  $scope.create = () ->
    post.$save(( () ->
      # success
      posts.push(post)
      post = new Post
    ), ( () ->
      # error
      errors = ErrSrvc.getErrors()
    ))

  $scope.update = () ->
    post.$update(( () ->
      # success
      post = new Post
      editMode = false
    ),(() ->
      # error
      errors = ErrSrvc.getErrors()
    ))

  $scope.delete = (id) ->
    i = _.findIndex(posts,['id',id])
    post = posts[i]
    post.$delete(( () ->
      # success
      posts.splice(i,1)
    ),( () ->
      # error
      errors = ErrSrvc.getErrors()
    ))

  posts = Post.query()

])
