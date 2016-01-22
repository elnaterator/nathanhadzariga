

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

  it 'should send Authorization header if token saved', () ->
    AuthSrvc.setToken('someToken')
    config = { headers: {}}
    AuthSrvc.request(config)
    expect(config.headers['Authorization']).toBe('Token token="someToken"')

  it 'should NOT send Authorization header if NO token saved', () ->
    config = { headers: {}}
    AuthSrvc.request(config)
    expect(config.headers['Authorization']).toBeUndefined()


  describe 'http interceptor', () ->

    it 'should add interceptor to $httpProvider', () ->
      expect($httpProvider.interceptors).toContain('AuthSrvc')

    it 'should send Authorization header when token set', () ->
      AuthSrvc.setToken('someToken')
      $httpBackend.expect('GET', 'http://example.com', null, (headers) ->
        return headers.Authorization == 'Token token="someToken"'
      ).respond(200,'')
      $http.get('http://example.com')
      $httpBackend.flush()

    it 'should NOT send Authorization header when token NOT set', () ->
      $httpBackend.expect('GET', 'http://example.com', null, (headers) ->
        return headers.Authorization == undefined
      ).respond(200,'')
      $http.get('http://example.com')
      $httpBackend.flush()
