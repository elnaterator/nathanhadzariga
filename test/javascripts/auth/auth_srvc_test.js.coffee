

describe 'AuthSrvc', () ->

  $httpProvider = null
  $httpBackend = null
  $http = null
  AuthSrvc = null

  beforeEach(() ->
    module('natesApp.auth', (_$httpProvider_) ->
      $httpProvider = _$httpProvider_
      spyOn($httpProvider.interceptors, 'push')
    )
    inject( (_AuthSrvc_, _$httpBackend_, _$http_) ->
      AuthSrvc = _AuthSrvc_
      $httpBackend = _$httpBackend_
      $http = _$http_
    )
  )

  afterEach( () ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
  )

  it 'should be defined', () ->
    expect(AuthSrvc).toBeDefined()

  it 'should store a token as a string', () ->
    AuthSrvc.setToken('someToken')
    expect(AuthSrvc.getToken()).toBe('someToken')
    

  describe '#getTokenClaims', () ->

    it 'should return the token claims', () ->
      claimsIn = {test:'value'}
      AuthSrvc.setToken(testToken(claimsIn))
      expect(AuthSrvc.getTokenClaims().test).toBe('value')

    it 'should return null when not logged in', () ->
      AuthSrvc.setToken(null)
      expect(AuthSrvc.getTokenClaims()).toBeNull()

    it 'should return null when invalid token', () ->
      AuthSrvc.setToken('someToken')
      expect(AuthSrvc.getTokenClaims()).toBeNull()


  describe '#isLoggedIn', () ->

    it 'should return false if no token stored', () ->
      AuthSrvc.setToken(null)
      expect(AuthSrvc.isLoggedIn()).toBe(false)

    it 'should return true if unexpired token stored', () ->
      claims = { exp: currTimeInSeconds() + 30 }
      AuthSrvc.setToken(testToken(claims))
      expect(AuthSrvc.isLoggedIn()).toBe(true)

    it 'should return false if expired token stored', () ->
      claims = { exp: currTimeInSeconds() - 30 }
      AuthSrvc.setToken(testToken(claims))
      expect(AuthSrvc.isLoggedIn()).toBe(false)


  describe '#isTokenExpired', () ->

    it 'should throw error for missing or invalid token', () ->
      AuthSrvc.setToken(null)
      expect(AuthSrvc.isTokenExpired).toThrowError()
      AuthSrvc.setToken('someToken')
      expect(AuthSrvc.isTokenExpired).toThrowError()

    it 'should be false for expired token', () ->
      claims = {exp: currTimeInSeconds() - 60}
      AuthSrvc.setToken(testToken(claims))
      expect(AuthSrvc.isTokenExpired()).toBe(true)

    it 'should be true for non expired token', () ->
      claims = {exp: currTimeInSeconds() + 60}
      AuthSrvc.setToken(testToken(claims))
      expect(AuthSrvc.isTokenExpired()).toBe(false)


  describe 'http interceptors', () ->

    it 'should add interceptor to $httpProvider', () ->
      expect($httpProvider.interceptors).toContain('AuthSrvc')

    describe 'sending token in request', () ->

      it 'should only send Authorization header if token is stored', () ->
        config = { headers: {}}
        # no token stored
        AuthSrvc.request(config)
        expect(config.headers['Authorization']).toBeUndefined()
        # with token stored
        AuthSrvc.setToken('someToken')
        AuthSrvc.request(config)
        expect(config.headers['Authorization']).toBe('Token token="someToken"')

      it 'should intercept http requests', () ->
        AuthSrvc.setToken('someToken')
        $httpBackend.expect('GET', 'http://example.com', null, (headers) ->
          return headers.Authorization == 'Token token="someToken"'
        ).respond(200,'')
        $http.get('http://example.com')
        $httpBackend.flush()

    describe 'receiving access token in response', () ->

      it 'should store the token if a token is received in a response', () ->
        mockResponse = {
          headers: () ->
            { access_token: 'someToken' }
        }
        AuthSrvc.response(mockResponse)
        expect(AuthSrvc.getToken()).toBe('someToken')

      it 'should intercept http responses', () ->
        $httpBackend.expect('GET', 'http://example.com')
          .respond(200,'',{ access_token: 'someToken' })
        $http.get('http://example.com')
        $httpBackend.flush()
        expect(AuthSrvc.getToken()).toBe('someToken')
