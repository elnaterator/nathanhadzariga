#
# User controller
#

UsersCtrl = ($scope, $http) ->

  $scope.editMode = false
  $scope.users = []
  $scope.user = {}
  $scope.errors = []

  # crud operations for users

  $scope.fetchUsers = () ->
    $http.get('/users').then( (response) ->
      $scope.users = response.data
    , errorHandler)

  $scope.createUser = () ->
    payload = {user: $scope.user}
    $http.post('/users',payload).then( (response) ->
      $scope.users.push response.data
      $scope.user = {}
    , errorHandler)

  $scope.deleteUser = (id) ->
    $http.delete('/users/'+id)
    index = indexById($scope.users,id)
    $scope.users.splice(index,1)

  $scope.updateUser = () ->
    payload = {user: $scope.user}
    $http.patch('/users/' + $scope.user.id, payload).then( (() ->), errorHandler)
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

  # error handling

  $scope.hasErrors = () ->
    return $scope.errors.length > 0

  errorHandler = (response) ->
    if response.status >= 400 && response.status < 500 # input error
      $scope.errors.push(buildErrMsg(k,v)) for k,v of response.data
    else # unknown error
      $scope.errors.push("I apologize for the inconvenience, but we seem to be having technical difficulties.")



app = angular.module('homeApp',[]).controller 'UsersCtrl', ['$scope','$http', UsersCtrl]

#
# helpers
#

buildErrMsg = (k,v) ->
  capitalize(k) + ' ' + v[0]

capitalize = (str) ->
  str.charAt(0).toUpperCase() + str.slice(1)

indexById = (objects, id) ->
  return i for obj, i in objects when obj.id==id
