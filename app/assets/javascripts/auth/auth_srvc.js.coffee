
#
# Authentication service for dealing with token
#
angular.module('natesApp.auth', ['ngResource'])

.factory('AuthSrvc', () ->

  token = null

  setToken = (t) ->
    token = t

  getToken = () ->
    token

  request = (config) ->
    config.headers['Authorization'] = 'Token token="' + token + '"' if(token)
    config

  return {
    setToken: setToken,
    getToken: getToken,
    request: request
  }
)

.config(['$httpProvider', ($httpProvider) ->
  $httpProvider.interceptors.push('AuthSrvc')
])
