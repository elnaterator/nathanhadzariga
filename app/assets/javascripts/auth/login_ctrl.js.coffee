angular.module('natesApp.auth')

.controller('LoginCtrl', ['$scope', 'User', 'AuthSrvc', '$location', ($scope, User, AuthSrvc, $location) ->

  $scope.user = new User()

  $scope.login = () ->
    $scope.user.$login()
    User.setCurrent($scope.user)
    $location.path('/')

])
