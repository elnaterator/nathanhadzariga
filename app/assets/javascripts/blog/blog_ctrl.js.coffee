angular.module('natesApp.blog',['ngResource','natesApp.err','natesApp.auth'])

.controller('BlogCtrl', ['$scope', 'Post', ($scope, Post) ->

  posts = []

  $scope.posts = () ->
    posts

  $scope.notLast = (elements, elem) ->
    len = elements.length
    return false if len <= 0
    return elements[len - 1].updated_at != elem.updated_at

  # initialization

  posts = Post.query()

])
