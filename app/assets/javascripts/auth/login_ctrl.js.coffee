angular.module('natesApp.auth')

.controller('LoginCtrl', ['$scope', 'User', ($scope, User) ->

  $scope.user = new User()

  $scope.login = () ->
    $scope.user.$login()

])
