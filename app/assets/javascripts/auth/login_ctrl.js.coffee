angular.module('natesApp.auth')

.controller('LoginCtrl', ['$scope', 'User', 'AuthSrvc', '$location', 'ErrorInterceptor', ($scope, User, AuthSrvc, $location, ErrorInterceptor) ->

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
        $scope.errors = _.concat($scope.errors, ErrorInterceptor.getErrors())
      )
    )

])
