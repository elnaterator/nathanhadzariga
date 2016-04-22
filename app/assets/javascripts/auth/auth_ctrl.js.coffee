angular.module('natesApp.auth', ['ngResource', 'natesApp.err'])

.controller('AuthCtrl', ['$scope', 'User', 'AuthSrvc', '$location', 'ErrSrvc', ($scope, User, AuthSrvc, $location, ErrSrvc) ->

  $scope.user = new User()
  $scope.isNewUser = false
  $scope.errors = []

  $scope.toggleNewUser = () ->
    $scope.errors = []
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
        $scope.errors = _.concat($scope.errors, ErrSrvc.getErrors())
      )
    )

])
