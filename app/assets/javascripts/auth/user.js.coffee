#
#
#

angular.module('natesApp.auth')

.factory('User', ['$resource', 'AuthSrvc', ($resource, AuthSrvc) ->

  tokenInterceptor = {
    response: (response) ->
      AuthSrvc.setToken(response.headers()['access_token'])
  }

  User = $resource('/users/:id', null, {
    login: {
      method: 'POST',
      url: '/users/login',
      interceptor: tokenInterceptor
    },
    signup: {
      method: 'POST',
      url: '/users/signup',
      interceptor: tokenInterceptor
    }
  })

  currentUser = undefined

  User.getCurrent = () ->
    currentUser

  User.setCurrent = (user) ->
    currentUser = user

  return User

])
