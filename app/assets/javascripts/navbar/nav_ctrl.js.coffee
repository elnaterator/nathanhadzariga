angular.module('natesApp.nav', ['natesApp.auth'])

.controller('NavCtrl', ['$scope', 'User', 'AuthSrvc', '$location', ($scope, User, AuthSrvc, $location) ->

  $scope.isLoggedIn = () ->
    !_.isNil(AuthSrvc.getToken())

  $scope.isAdmin = () ->
    t = AuthSrvc.getToken()
    return false if !t || !typeof(t) == 'string'
    arr = t.split('.')
    return false if arr.length != 3
    encodedClaims = arr[1]
    claims = JSON.parse(atob(encodedClaims))
    return false if !claims || !claims.role || claims.role != 'ADMIN'
    return true

  $scope.getUser = () ->
    User.getCurrent()

  $scope.logout = () ->
    User.logout()
    $location.path('/login')

])
