#
# User controller
#
indexById = (objects, id) ->
  return i for obj, i in objects when obj.id==id

UsersCtrl = ($scope, $http) ->

  $scope.editMode = false
  $scope.users = []
  $scope.user = {}

  # crud operations for users

  $scope.fetchUsers = () ->
    $http.get('/users').then( (response) ->
      $scope.users = response.data
    )

  $scope.createUser = () ->
    payload = $scope.user
    $http.post('/users',payload).then( (response) ->
      $scope.users.push response.data
      $scope.user = {}
    )

  $scope.deleteUser = (id) ->
    $http.delete('/users/'+id)
    index = indexById($scope.users,id)
    $scope.users.splice(index,1)

  $scope.updateUser = () ->
    payload = $scope.user
    $http.patch('/users/' + $scope.user.id, payload)
    $scope.user = {}
    $scope.editMode = false

  # edit mode helpers

  $scope.editUser = (id) ->
    index = indexById($scope.users,id)
    $scope.user = $scope.users[index]
    $scope.editMode = true

  $scope.cancelEdit = () ->
    $scope.user = {}
    $scope.editMode = false

app = angular.module('homeApp',[]).controller 'UsersCtrl', ['$scope','$http', UsersCtrl]
