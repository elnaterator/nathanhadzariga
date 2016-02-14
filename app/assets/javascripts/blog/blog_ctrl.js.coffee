angular.module('natesApp.blog',['ngResource','natesApp.err'])

.controller('BlogCtrl', ['$scope', 'Post', ($scope, Post) ->

  posts = []

  $scope.posts = () ->
    posts

  # initialization

  posts = Post.query()

])
