angular.module('natesApp.blog',['ngResource','natesApp.err','natesApp.auth'])

.controller('BlogCtrl', ['$scope', 'Post', ($scope, Post) ->

  posts = []

  $scope.posts = () ->
    posts

  # initialization

  posts = Post.query()

])
