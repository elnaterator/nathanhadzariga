angular.module('natesApp.blog')

.factory('Post', ['$resource', ($resource) ->

  Post = $resource('/posts/:id', {id:'@id'})

  return Post

])
