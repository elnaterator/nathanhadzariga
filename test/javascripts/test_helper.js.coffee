triggerKeyUp = (elem, keyCode) ->
  console.info angular.element().Event
  e = angular.element.Event('keyup')
  e.which = keyCode
  element.trigger(e)

testToken = (claimsObj) ->
  header = "1uy89yfhuiweu"
  claims = btoa(JSON.stringify(claimsObj))
  signature = "ufieoqhuufie89"
  return header + "." + claims + "." + signature

currTimeInSeconds = () ->
  return Math.round(new Date().getTime() / 1000)
