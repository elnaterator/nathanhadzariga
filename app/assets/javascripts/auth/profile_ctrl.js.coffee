angular.module('natesApp.auth')

.controller('ProfileCtrl', ['$scope', 'User', '$location', ($scope, User, $location) ->

  $scope.user = () ->
    User.getCurrent()

  $scope.deleteConfirm = false

  $scope.toggleDeleteConfirm = () ->
    $scope.deleteConfirm = !$scope.deleteConfirm
    
  $scope.delete = () ->
    user = User.getCurrent()
    user.$delete(( () ->
      User.logout()
      $location.path('/')
    ))

])
