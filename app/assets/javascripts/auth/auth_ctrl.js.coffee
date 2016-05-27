angular.module('natesApp.auth', ['ngResource', 'natesApp.err'])

.controller('AuthCtrl', ['$scope', 'User', 'AuthSrvc', '$location', 'ErrSrvc', ($scope, User, AuthSrvc, $location, ErrSrvc) ->

  $scope.user = new User()
  $scope.isNewUser = false
  errors = []

  $scope.toggleNewUser = () ->
    errors = []
    $scope.isNewUser = !$scope.isNewUser

  $scope.login = () ->
    errors = []
    $scope.user.$login(
      ( () ->
        User.setCurrent($scope.user)
        $location.path('/')
      ),
      ( (response) ->
        errors = ['Invalid email or password.']
      )
    )

  $scope.signup = () ->
    errors = []
    $scope.user.$signup(
      ( () ->
        User.setCurrent($scope.user)
        $location.path('/')
      ),
      ( (response) ->
        errors = _.concat(errors, ErrSrvc.getErrors())
      )
    )

  $scope.errors = () ->
    errors

])
