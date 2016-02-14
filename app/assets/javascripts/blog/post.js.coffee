angular.module('natesApp.blog')

.factory('Post', ['$resource', ($resource) ->

  Post = $resource('/posts/:id', {id:'@id'}, {
    update: { method: 'PATCH' }
  })

  return Post

])
