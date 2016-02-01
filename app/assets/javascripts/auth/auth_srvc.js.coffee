
#
# Authentication service for dealing with token
#
angular.module('natesApp.auth', ['ngResource', 'natesApp.err'])

.factory('AuthSrvc', ['$q', ($q) ->

  tokenKey = 'natesApp-token'

  token = null

  setToken = (t) ->
    if typeof(Storage) != 'undefined'
      localStorage.removeItem(tokenKey) if !t
      localStorage.setItem(tokenKey,t)
    token = t

  getToken = () ->
    return token if token
    if typeof(Storage) != 'undefined'
      t = localStorage.getItem(tokenKey)
      token = t if t && _(t).includes('.')
    return token

  request = (config) ->
    config.headers['Authorization'] = 'Token token="' + token + '"' if(token)
    config

  response = (response) ->
    token = response.headers()['access_token']
    setToken(token) if token
    response

  return {
    setToken: setToken,
    getToken: getToken,
    request: request,
    response: response
  }
])

.config(['$httpProvider', ($httpProvider) ->
  $httpProvider.interceptors.push('AuthSrvc')
])
