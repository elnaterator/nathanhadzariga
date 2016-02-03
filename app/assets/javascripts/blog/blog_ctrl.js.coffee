angular.module('natesApp.blog',['ngResource'])

.controller('BlogCtrl', ['$scope', 'Post', ($scope, Post) ->

  posts = []

  $scope.posts = () ->
    posts

  # initialization

  posts = Post.query()

])
