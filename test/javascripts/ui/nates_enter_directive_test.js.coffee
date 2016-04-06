describe 'natesEnter directive', () ->

  $compile = null
  $scope = null
  count = 0

  beforeEach( () ->
    module('natesApp.ui')
    inject( (_$compile_, $rootScope) ->
      $compile = _$compile_
      $scope = $rootScope.$new()
      count = 0
      $scope.test = () ->
        count++
    )
  )

  it 'should do stuff', () ->
    expect(count).toBe(0)
    elem = getCompiledElem('<input id="test" nates-keyup="test()"></input>')
    triggerKeyUp(elem,13)

  getCompiledElem = (html) ->
    elem = angular.element(html)
    compiledElem = $compile(elem)($scope)
    $scope.$digest()
    return compiledElem
