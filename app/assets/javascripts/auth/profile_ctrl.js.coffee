angular.module('natesApp.auth')

.controller('ProfileCtrl', ['$scope', 'User', '$location', 'ErrSrvc', ($scope, User, $location, ErrSrvc) ->

  confirmDeleteMode = false
  editMode = false
  cachedUserProps = null
  errors = []

  $scope.user = () ->
    User.getCurrent()

  $scope.confirmDeleteMode = (cdm) ->
    return confirmDeleteMode if _(cdm).isUndefined()
    if cdm
      confirmDeleteMode = true
    else
      confirmDeleteMode = false
    confirmDeleteMode

  $scope.delete = () ->
    user = User.getCurrent()
    user.$delete(( () ->
      User.logout()
      $location.path('/')
    ))

  $scope.editMode = (em) ->
    return editMode if _(em).isUndefined()
    if em
      editMode = true
      cacheUser()
    else
      editMode = false
      resetUser()
    editMode

  cacheUser = () ->
    cachedUserProps = _.pick(User.getCurrent(),['name','email'])

  resetUser = () ->
    u = User.getCurrent()
    if cachedUserProps
      for k,v of cachedUserProps
        u[k] = v
      cachedUserProps = null

  $scope.updateUser = () ->
    User.getCurrent().$update(
      ( () ->
        # success
        editMode = false
        cachedUserProps = null
      ), ( () ->
        # errors
        errors = ErrSrvc.getErrors()
      )
    )

  $scope.errors = () ->
    errors

])
