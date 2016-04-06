triggerKeyUp = (elem, keyCode) ->
  console.info angular.element().Event
  e = angular.element.Event('keyup')
  e.which = keyCode
  element.trigger(e)
