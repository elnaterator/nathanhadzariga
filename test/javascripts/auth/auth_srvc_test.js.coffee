

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

  it 'should store a token', () ->
    AuthSrvc.setToken('someToken')
    expect(AuthSrvc.getToken()).toBe('someToken')


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
