#
#
#

angular.module('natesApp.auth')

.factory('User', ['$resource', 'AuthSrvc', ($resource, AuthSrvc) ->

  currentUser = undefined

  User = $resource('/users/:id', null, {
    login: { method: 'POST', url: '/users/login', interceptor: {
      response: (response) ->
        currentUser = new User(response.data)
        AuthSrvc.setToken(response.headers()['access_token'])
    }}
  })

  User.getCurrent = () ->
    currentUser

  User.setCurrent = (user) ->
    currentUser = user

  return User

])
