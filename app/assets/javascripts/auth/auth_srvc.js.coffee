
#
# Authentication service for dealing with token
#
angular.module('natesApp.auth')

.factory('AuthSrvc', ['$q', ($q) ->

  tokenKey = 'natesApp-token'

  token = null

  # helpers

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

  getTokenClaims = () ->
    try
      return JSON.parse(atob(getToken().split('.')[1]))
    catch error
      return null

  isLoggedIn = () ->
    claims = getTokenClaims()
    return false if !claims
    return false if isTokenExpired(claims)
    return true

  isTokenExpired = (tokenClaims)->
    tokenClaims = getTokenClaims() if !tokenClaims
    throw new Error('No token, unable to check if its expired.') if !tokenClaims
    return !tokenClaims.exp || tokenClaims.exp <= Math.round(new Date().getTime() / 1000)

  # http interceptor

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
    getTokenClaims: getTokenClaims,
    isLoggedIn: isLoggedIn,
    isTokenExpired: isTokenExpired,
    request: request,
    response: response
  }
])

.config(['$httpProvider', ($httpProvider) ->
  $httpProvider.interceptors.push('AuthSrvc')
])
