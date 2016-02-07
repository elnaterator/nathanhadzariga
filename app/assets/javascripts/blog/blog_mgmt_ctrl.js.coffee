angular.module('natesApp.blog')

.controller('BlogMgmtCtrl', ['$scope', 'Post', ($scope, Post) ->

  posts = []
  post = new Post
  editMode = false

  $scope.posts = () ->
    posts

  $scope.post = () ->
    post

  $scope.editMode = (em) ->
    if em != undefined
      if em
        editMode = true
      else
        editMode = false
    editMode

  $scope.edit = (id) ->
    i = _.findIndex(posts,['id',id])
    post = posts[i]
    editMode = true

  $scope.create = () ->
    post.$save(( () ->
      # success
      posts.push(post)
      post = new Post
    ), ( () ->
      # error
    ))

  posts = Post.query()

])
