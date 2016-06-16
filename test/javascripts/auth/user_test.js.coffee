
describe 'User', () ->

  User = undefined
  $httpBackend = undefined
  AuthSrvc = undefined
  beforeEach(() ->
    module('natesApp.auth')
    inject((_User_, _$httpBackend_, _AuthSrvc_) ->
      User = _User_
      $httpBackend = _$httpBackend_
      AuthSrvc = _AuthSrvc_
    )
  )

  afterEach( () ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
  )

  it 'class should be defined', () ->
    expect(User).toBeDefined()

  it 'should be instantiable', () ->
    user = new User({id: 123, name: 'Henry', email: 'test@email.com'})
    expect(user.id).toBe(123)
    expect(user.name).toBe('Henry')
    expect(user.email).toBe('test@email.com')

  it 'should store the current (logged in) in user', () ->
    User.setCurrent(new User({id: 123, name: 'Henry', email: 'test@email.com'}))
    currUser = User.getCurrent()
    expect(currUser.name).toBe('Henry')

  describe '#login', () ->

    it 'should send login request to backend', () ->
      $httpBackend.expect('POST', '/users/login', { email: 'henry@test.com', password: 'password' })
        .respond(200, { id: 123, name: 'Henry', email: 'henry@test.com' })
      user = new User({ email: 'henry@test.com', password: 'password' })
      user.$login()
      $httpBackend.flush()

    describe 'with success response', () ->

      beforeEach( () ->
        $httpBackend.expect('POST', '/users/login', { email: 'henry@test.com', password: 'password' })
          .respond(200, { id: 123, name: 'Henry', email: 'henry@test.com' }, {access_token: 'someToken'})
        user = new User({ email: 'henry@test.com', password: 'password' })
        user.$login()
        $httpBackend.flush()
      )

      it 'should store access token', () ->
        expect(AuthSrvc.getToken()).toBe('someToken')

  describe '#logout', () ->

    it 'should delete token and current user', () ->
      AuthSrvc.setToken('someToken')
      User.setCurrent(new User({name:'Henry'}))
      User.logout()
      expect(AuthSrvc.getToken()).toBeNull()
      expect(User.getCurrent()).toBeNull()

  describe '#refreshToken', () ->

    it 'should send refresh token request and save response token', () ->
      AuthSrvc.setToken('someToken')
      $httpBackend.expect('POST', '/users/refresh', {}, (headers) ->
        return headers.Authorization == 'Token token="someToken"'
      ).respond(200, {}, {access_token: 'anotherToken'})
      user = new User({})
      user.$refreshToken()
      $httpBackend.flush()
      expect(AuthSrvc.getToken()).toBe('anotherToken')
