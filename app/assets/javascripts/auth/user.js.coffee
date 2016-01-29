#
#
#

angular.module('natesApp.auth')

.factory('User', ['$resource', 'AuthSrvc', ($resource, AuthSrvc) ->

  setToken = (response) ->
    AuthSrvc.setToken(response.headers()['access_token'])

  User = $resource('/users/:id', { id: '@id' }, {
    login: {
      method: 'POST',
      url: '/users/login',
      interceptor: { response: setToken }
    },
    signup: {
      method: 'POST',
      url: '/users/signup',
      interceptor: { response: setToken }
    }
  })

  currentUser = undefined

  User.getCurrent = () ->
    currentUser

  User.setCurrent = (user) ->
    currentUser = user

  User.logout = () ->
    AuthSrvc.setToken(null)
    currentUser = null

  return User

])
