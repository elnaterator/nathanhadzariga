#
#
#

angular.module('natesApp.auth')

.factory('User', ['$resource', 'AuthSrvc', ($resource, AuthSrvc) ->

  User = $resource('/users/:id', { id: '@id' }, {
    update: {
      method: 'PATCH'
    },
    login: {
      method: 'POST',
      url: '/users/login',
    },
    signup: {
      method: 'POST',
      url: '/users/signup',
    }
  })

  loadUser = () ->
    token = AuthSrvc.getToken()
    if token
      encodedClaims = token.split('.')[1]
      claims = JSON.parse(atob(encodedClaims))
      user = User.get({id: claims.user_id})
      user

  currentUser = loadUser() || undefined

  User.getCurrent = () ->
    currentUser

  User.setCurrent = (user) ->
    currentUser = user

  User.logout = () ->
    AuthSrvc.setToken(null)
    currentUser = null

  return User

])
