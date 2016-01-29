angular.module('natesApp.auth')

.controller('NavCtrl', ['$scope', 'User', 'AuthSrvc', '$location', ($scope, User, AuthSrvc, $location) ->

  $scope.isLoggedIn = () ->
    !_.isNil(AuthSrvc.getToken())

  $scope.getUser = () ->
    User.getCurrent()

  $scope.logout = () ->
    User.logout()
    $location.path('/login')

])
