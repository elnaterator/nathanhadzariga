angular.module('natesApp.auth', ['ngResource', 'natesApp.err'])

.controller('AuthCtrl', ['$scope', '$rootScope', 'User', 'AuthSrvc', '$location', 'ErrSrvc', ($scope, $rootScope, User, AuthSrvc, $location, ErrSrvc) ->

  $scope.user = new User()
  $scope.isNewUser = false

  $scope.toggleNewUser = () ->
    $scope.isNewUser = !$scope.isNewUser

  $scope.login = () ->
    $scope.user.$login(
      ( () ->
        User.setCurrent($scope.user)
        $location.path('/')
      ),
      ( (response) ->
        $rootScope.flashNow('Invalid email or password.', 'error')
      )
    )

  $scope.signup = () ->
    $scope.user.$signup(
      ( () ->
        User.setCurrent($scope.user)
        $location.path('/')
      ),
      ( (response) ->
        $rootScope.flashNow(ErrSrvc.getErrors(), 'error')
      )
    )

  $scope.$on '$viewContentLoaded', () ->
    document.getElementById('login-email').focus()

])
