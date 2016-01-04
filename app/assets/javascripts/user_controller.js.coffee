#
# User controller
#

UserCtrl = ($scope, $http) ->
  $scope.users = []
  $scope.fetchUsers = () ->
    $http.get('/users').then( (response) ->
      $scope.users = response.data
    )

app = angular.module('homeApp',[]).controller 'UserCtrl', ['$scope','$http', UserCtrl]
