#
#
#

angular.module('natesApp.auth')

.factory('User', ['$resource', 'AuthSrvc', ($resource, AuthSrvc) ->

  setToken = (response) ->
    AuthSrvc.setToken(response.headers()['access_token'])

  extractErrorMessages = (response) ->
    errors = []
    errors.push(errorMsg(k,v)) for k,v of response.data
    errors

  handleErrors = (response) ->
    this.errors = []
    if response.status >= 500
      errors = ['I apologize for the inconvenience, but we seem to be having technical difficulties right now.']
    else if response.status >= 400 && _.isObject(response.data)
      errors = extractErrorMessages(response)
    errors

  setErrorMessages = (response) ->



  User = $resource('/users/:id', null, {
    login: {
      method: 'POST',
      url: '/users/login',
      interceptor: { response: setToken, responseError: setErrorMessages }
    },
    signup: {
      method: 'POST',
      url: '/users/signup',
      interceptor: { response: setToken, responseError: setErrorMessages }
    }
  })

  currentUser = undefined

  User.getCurrent = () ->
    currentUser

  User.setCurrent = (user) ->
    currentUser = user

  return User

])
