#
# User controller
#

UsersCtrl = ($scope, $http) ->

  $scope.editMode = false
  $scope.users = []
  $scope.user = {}
  userCache = {}
  $scope.errors = []

  # crud operations for users

  $scope.fetchUsers = () ->
    $scope.clearErrors()
    $http.get('/users').then( (response) ->
      $scope.users = response.data
    , errorHandler)

  $scope.createUser = () ->
    $scope.clearErrors()
    payload = {user: $scope.user}
    $http.post('/users',payload).then( (response) ->
      $scope.users.push response.data
      $scope.user = {}
    , errorHandler)

  $scope.deleteUser = (id) ->
    $scope.clearErrors()
    $http.delete('/users/'+id)
    index = indexById($scope.users,id)
    $scope.users.splice(index,1)

  $scope.updateUser = () ->
    $scope.clearErrors()
    usr = $scope.user
    payload = {user: usr}
    $http.patch('/users/' + usr.id, payload).then( ((response) ->
      # success
      $scope.user = {}
      $scope.editMode = false
    ), errorHandler)

  # edit mode helpers

  $scope.editUser = (id) ->
    $scope.clearErrors()
    index = indexById($scope.users,id)
    $scope.user = $scope.users[index]
    userCache = JSON.parse(JSON.stringify($scope.user))
    $scope.editMode = true

  $scope.cancelEdit = () ->
    $scope.clearErrors()
    $scope.user.name = userCache.name
    $scope.user.email = userCache.email
    $scope.user = {}
    $scope.editMode = false

  # error handling

  $scope.hasErrors = () ->
    $scope.errors.length > 0

  $scope.getErrors = () ->
    $scope.errors

  $scope.clearErrors = () ->
    $scope.errors = []

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

clone = (src,dest) ->
  dest[key] = val for key, val of src
