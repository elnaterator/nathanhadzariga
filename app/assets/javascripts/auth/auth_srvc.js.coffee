
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

  hasValidToken = () ->
    token = getToken()
    return false if !token
    try
      claims = JSON.parse(atob(token.split('.')[1]))
      # check expired
      expSeconds = claims.exp
      currSeconds = Math.round(new Date().getTime() / 1000)
      # if it will expire in less than 15 seconds, just consider it expired
      return (expSeconds - currSeconds) > 15
    catch error
      return false

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
    hasValidToken: hasValidToken,
    request: request,
    response: response
  }
])

.config(['$httpProvider', ($httpProvider) ->
  $httpProvider.interceptors.push('AuthSrvc')
])
