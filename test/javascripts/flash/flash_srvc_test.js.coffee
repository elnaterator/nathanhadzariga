describe 'FlashSrvc', () ->

  FlashSrvc = null
  $rootScope = null

  beforeEach(() ->
    module('natesApp.flash')
    inject( (_FlashSrvc_, _$rootScope_) ->
      FlashSrvc = _FlashSrvc_
      $rootScope = _$rootScope_
    )
  )

  it 'should be defined and have proper functions', () ->
    expect(FlashSrvc).toBeDefined()
    expect(FlashSrvc.flash).toBeDefined()
    expect(FlashSrvc.flashNow).toBeDefined()

  describe '#flashNow', () ->

    it 'should add messages to $rootScope.flashMessages immediately', () ->
      FlashSrvc.flashNow('This is my message', 'note')
      expect($rootScope.flashMessages.length).toBe(1)
      expect($rootScope.flashMessages[0].msg).toBe('This is my message')
      expect($rootScope.flashMessages[0].type).toBe('note')

  describe '#flash', () ->

    it 'should not add message to $rootScope.flashMessages until after a view is rendered', () ->
      FlashSrvc.flash('This is my message', 'note')
      expect($rootScope.flashMessages.length).toBe(0)
      $rootScope.$broadcast('$viewContentLoaded')
      expect($rootScope.flashMessages.length).toBe(1)
      expect($rootScope.flashMessages[0].msg).toBe('This is my message')
      expect($rootScope.flashMessages[0].type).toBe('note')

  it 'should clear flash messages after another view is rendered', () ->
    FlashSrvc.flashNow('This is my message', 'note')
    expect($rootScope.flashMessages.length).toBe(1)
    $rootScope.$broadcast('$viewContentLoaded')
    expect($rootScope.flashMessages.length).toBe(0)
