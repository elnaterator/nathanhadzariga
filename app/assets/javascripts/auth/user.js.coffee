#
#
#

angular.module('natesApp.auth')

.factory('User', ['$resource', 'AuthSrvc', ($resource, AuthSrvc) ->

  User = $resource('/users/:id', null, {
    login: {
      method: 'POST',
      url: '/users/login',
      interceptor: {
        response: (response) ->
          AuthSrvc.setToken(response.headers()['access_token'])
      }
    }
  })

  currentUser = undefined

  User.getCurrent = () ->
    currentUser

  User.setCurrent = (user) ->
    currentUser = user

  return User

])
