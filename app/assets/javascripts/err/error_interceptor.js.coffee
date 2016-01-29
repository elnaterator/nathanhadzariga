angular.module('natesApp.err', [])

.factory('ErrorInterceptor', ['$q', ($q) ->

  errors = []

  getErrors = () ->
    return errors

  buildMessages = (jsonResp) ->
    return null if !_.isPlainObject(jsonResp)
    msgs = []
    for k, v of jsonResp
      msgs.push(_.capitalize(_.lowerCase(k)) + ' ' + v[0] + '.') if _.isArray(v)
    msgs

  response = (response) ->
    errors = []
    response

  responseError = (response) ->
    errors = buildMessages(response.data)
    errors = [response.statusText] if !errors
    $q.reject(response)

  return {
    getErrors: getErrors,
    buildMessages: buildMessages,
    response: response,
    responseError: responseError
  }

])

.config(['$httpProvider', ($httpProvider) ->
  $httpProvider.interceptors.push('ErrorInterceptor')
])
