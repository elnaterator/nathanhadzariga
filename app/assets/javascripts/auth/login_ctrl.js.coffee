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
      ( () ->
        $scope.errors.push('Invalid email or password.')
      )
    )

  $scope.signup = () ->
    $scope.errors = []
    $scope.user.$create(
      ( () ->
        console.info 'success'
      ),
      ( () ->
        console.info 'failure'
      )
    )

])