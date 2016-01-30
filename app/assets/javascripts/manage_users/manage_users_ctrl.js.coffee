angular.module('natesApp.manageUsers',['natesApp.auth', 'natesApp.err'])

#
# User controller
#

.controller('ManageUsersCtrl', ['$scope','$http', 'User', 'AuthSrvc', 'ErrorInterceptor', ($scope, $http, User, AuthSrvc, ErrorInterceptor) ->

  # initialization

  users = []
  user = new User
  editMode = false

  AuthSrvc.getToken()
  users = User.query()

  # basic accessors

  $scope.editMode = (em) ->
    if em == false
      user = new User
      editMode = false
    editMode

  $scope.users = (ul) ->
    users = ul if ul
    users

  $scope.user = (u) ->
    user = u if u
    user

  # edit mode

  $scope.editUser = (id) ->
    index = _.findIndex(users,['id',id])
    user = users[index]
    #userCache = JSON.parse(JSON.stringify($scope.user))
    editMode = true

  # crud operations for users

  $scope.createUser = () ->
    user.$save(( () ->
      users.push(user)
      user = new User
    ), ( () ->
      # error
    ))

  $scope.updateUser = () ->
    user.$update(( () ->
      user = new User
      editMode = false
    ), ( () ->
      # error
    ))

  $scope.deleteUser = (id) ->
    User.remove({id:id}, () ->
      index = _.findIndex(users,['id',id])
      users.splice(index,1)
    )


  $scope.fetchUsers = () ->
    $scope.users = User.query()



  # edit mode helpers





  # error handling

  $scope.errors = () ->
    ErrorInterceptor.getErrors()

])
