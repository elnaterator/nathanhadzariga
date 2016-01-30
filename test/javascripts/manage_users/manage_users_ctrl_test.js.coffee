describe 'ManageUsersCtrl', () ->
  beforeEach(module('natesApp.manageUsers'))

  $httpBackend = null
  $controller = null
  $scope = null
  AuthSrvc = null
  User = null

  beforeEach( inject( (_$httpBackend_, _$controller_, _AuthSrvc_, _User_) ->
    $httpBackend = _$httpBackend_
    $controller = _$controller_
    AuthSrvc = _AuthSrvc_
    User = _User_
    $scope = {}
  ))

  afterEach( () ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
  )

  it 'should load users on initialization', () ->
    $httpBackend.expect('GET', '/users').respond([{"id":123, "name":"Bill", "email":"bill@email.com"}])
    $controller('ManageUsersCtrl', { $scope : $scope })
    $httpBackend.flush()
    users = $scope.users()
    expect(users.length).toBe(1)
    expect(users[0].id).toBe(123)

  describe '(initialized)', () ->

    beforeEach( () ->
      $httpBackend.expect('GET', '/users')
        .respond([{id:123,name:'Bill',email:'bill@email.com'},{id:456,name:'Joe',email:'joe@email.com'}])
      $controller('ManageUsersCtrl', { $scope : $scope })
      $httpBackend.flush()
    )

    # edit mode

    describe 'edit mode', () ->

      it 'should set user and editMode', () ->
        $scope.editUser(123)
        expect($scope.editMode()).toBe(true)
        expect($scope.user().name).toBe('Bill')
        $scope.editUser(456)
        expect($scope.editMode()).toBe(true)
        expect($scope.user().name).toBe('Joe')

      it 'should turn off edit mode', () ->
        $scope.editUser(123)
        $scope.editMode(false)
        expect($scope.editMode()).toBe(false)
        expect($scope.user().name).toBeUndefined()

      it 'should reset any changes made to user when turning off edit mode', () ->
        $scope.editUser(456)
        $scope.user().email = 'invalidemail'
        $scope.editMode(false)
        i = _.findIndex($scope.users(),['id',456])
        user = $scope.users()[i]
        expect(user.email).toBe('joe@email.com')

    #
    # CRUD tests
    #

    describe 'crud operation', () ->

      # create

      describe 'create new user', () ->

        describe 'successfully', () ->

          beforeEach( () ->
            $scope.user(new User({name:'Bill',email:'bill@email.com',password:'password',password_confirmation:'password'}))
            $httpBackend.expect('POST', '/users',
              {name: 'Bill', email: 'bill@email.com', password: 'password', password_confirmation: 'password'})
              .respond({"id":999, "name":"Bill", "email":"bill@email.com" })
            $scope.createUser()
            $httpBackend.flush()
          )

          it 'should hit backend with create action and add user to users', () ->
            expect($scope.users().length).toBe(3)
            expect($scope.users()[2].id).toBe(999)

          it 'should clean up user on scope', () ->
            expect($scope.user().name).toBeUndefined()

        describe 'with errors', () ->

          beforeEach( () ->
            $scope.user(new User({name:'Bill',email:'bill@email.com',password:'password',password_confirmation:'password'}))
            $httpBackend.expect('POST', '/users',
              {name: 'Bill', email: 'bill@email.com', password: 'password', password_confirmation: 'password'})
              .respond(422, {email:['is invalid format'],password:['is required']})
            $scope.createUser()
            $httpBackend.flush()
          )

          it 'should put errors on scope', () ->
            expect($scope.errors().length).toBe(2)
            expect($scope.errors()[0]).toBe('Email is invalid format.')

          it 'should leave user on scope', () ->
            expect($scope.user().name).toBe('Bill')

      # update

      describe 'update user', () ->

        describe 'successfully', () ->

          beforeEach( () ->
            $scope.editUser(123)
            $scope.user().email = 'bill@example.com'
            $httpBackend.expect('PATCH', '/users/123',
              {id:123,name:'Bill',email: 'bill@example.com'})
              .respond({"id":123,"name":"Bill","email":"bill@example.com"})
            $scope.updateUser()
            $httpBackend.flush()
          )

          it 'should send update request, clear user from scope, and reset editMode', () ->
            expect($scope.user().name).toBeUndefined()
            expect($scope.editMode()).toBe(false)

        describe 'with errors', () ->

          beforeEach( () ->
            $scope.editUser(123)
            $scope.user().email = 'bill@example.com'
            $httpBackend.expect('PATCH', '/users/123',
              {id:123,name:'Bill',email: 'bill@example.com'})
              .respond(422, {email:['is invalid format'],password:['is required']})
            $scope.updateUser()
            $httpBackend.flush()
          )

          it 'should put errors on scope', () ->
            expect($scope.errors().length).toBe(2)
            expect($scope.errors()[0]).toBe('Email is invalid format.')

          it 'should leave user on scope', () ->
            expect($scope.user().name).toBe('Bill')

      # delete

      describe 'delete user', () ->

        describe 'successfully', () ->

          beforeEach( () ->
            $httpBackend.expect('DELETE', '/users/123').respond(200,{})
            $scope.deleteUser(123)
            $httpBackend.flush()
          )

          it 'should send delete request and remove user from list', () ->
            expect($scope.users().length).toBe(1)

        describe 'with errors', () ->

          beforeEach( () ->
            $httpBackend.expect('DELETE', '/users/123')
              .respond(422, {email:['is invalid format'],password:['is required']})
            $scope.deleteUser(123)
            $httpBackend.flush()
          )

          it 'should put errors on scope', () ->
            expect($scope.errors().length).toBe(2)
            expect($scope.errors()[0]).toBe('Email is invalid format.')

          it 'should leave user in users', () ->
            expect($scope.users().length).toBe(2)
