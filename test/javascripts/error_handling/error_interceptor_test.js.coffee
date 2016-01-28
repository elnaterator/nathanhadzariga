describe 'ErrorInterceptor', () ->

  $httpProvider = null
  $httpBackend = null
  $http = null
  ErrorInterceptor = null

  beforeEach(() ->
    module('natesApp.err', (_$httpProvider_) ->
      $httpProvider = _$httpProvider_
      spyOn($httpProvider.interceptors, 'push')
    )
    inject( (_ErrorInterceptor_, _$httpBackend_, _$http_) ->
      ErrorInterceptor = _ErrorInterceptor_
      $httpBackend = _$httpBackend_
      $http = _$http_
    )
  )

  afterEach( () ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
  )

  it 'should be added to interceptors', () ->
    expect(ErrorInterceptor).toBeDefined()
    expect($httpProvider.interceptors).toContain('ErrorInterceptor')

  describe 'buildMessages', () ->

    it 'should build list of error messages from json response', () ->
      jsonResp = { myfield: ['is missing'], yourfield: ['has an error', 'second message is ignored']}
      messages = ErrorInterceptor.buildMessages(jsonResp)
      expect(messages.length).toBe(2)
      expect(messages[0]).toBe('Myfield is missing.')
      expect(messages[1]).toBe('Yourfield has an error.')

    it 'should return null response for invalid json response', () ->
      jsonResp = ['this', 'is', 'a', 'list']
      expect(ErrorInterceptor.buildMessages(jsonResp)).toBeNull()
      jsonResp = "this is a string"
      expect(ErrorInterceptor.buildMessages(jsonResp)).toBeNull()
      jsonResp = { valid: ['message'], invalid: 'message', anotherinvalid: { message: 'here' }}
      msgs = ErrorInterceptor.buildMessages(jsonResp)
      expect(msgs.length).toBe(1)
      expect(msgs[0]).toBe('Valid message.')

  describe '4XX errors', () ->

    it 'with errors in body should store those errors', () ->
      $httpBackend.expect('GET', 'http://example.com')
        .respond(421, { field1: ['is missing'], field2: ['is invalid'] })
      $http.get('http://example.com')
      $httpBackend.flush()
      errors = ErrorInterceptor.getErrors()
      expect(errors.length).toBe(2)
      expect(errors[0]).toBe('Field1 is missing.')
      expect(errors[1]).toBe('Field2 is invalid.')

    it 'with no errors in body, should give generic user message', () ->
      $httpBackend.expect('GET', 'http://example.com').respond(421, '')
      $http.get('http://example.com')
      $httpBackend.flush()
      errors = ErrorInterceptor.getErrors()
      expect(errors.length).toBe(1)
