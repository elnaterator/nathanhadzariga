angular.module('natesApp.manageUsers',['natesApp.auth', 'natesApp.err'])

#
# User controller
#

.controller('ManageUsersCtrl', ['$scope','$http', 'User', 'AuthSrvc', 'ErrorInterceptor', ($scope, $http, User, AuthSrvc, ErrorInterceptor) ->

  # initialization

  users = []
  user = new User
  editMode = false
  cachedUserProps = null # for edit

  AuthSrvc.getToken()
  users = User.query()

  # reset cached user props
  resetCachedUser = () ->
    if cachedUserProps
      i = _.findIndex(users,['id',cachedUserProps.id])
      u = users[i]
      for k,v of cachedUserProps
        u[k] = v
      cachedUserProps = null

  # basic accessors

  $scope.editMode = (em) ->
    if em == false
      user = new User
      editMode = false
      resetCachedUser()
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
    cachedUserProps = _.pick(user,['id','name','email'])
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
