angular.module('natesApp.auth')

.controller('LoginCtrl', ['$scope', 'User', 'AuthSrvc', '$location', ($scope, User, AuthSrvc, $location) ->

  $scope.user = new User()
  $scope.isNewUser = false
  $scope.errors = []

  $scope.toggleNewUser = () ->
    $scope.isNewUser = !$scope.isNewUser

  $scope.login = () ->
    $scope.errors = []
    $scope.user.$login(
      ( () ->
        User.setCurrent($scope.user)
        $location.path('/')
      ),
      ( (response) ->
        $scope.errors.push('Invalid email or password.')
      )
    )

  $scope.signup = () ->
    $scope.errors = []
    $scope.user.$signup(
      ( () ->
        User.setCurrent($scope.user)
        $location.path('/')
      ),
      ( (response) ->
        $scope.errors.push('Something was wrong with what you sent me.')
      )
    )

])
