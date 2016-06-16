angular.module('natesApp.flash', [])

.factory('FlashSrvc', [ '$rootScope', ($rootScope) ->

  flashMessages = []
  $rootScope.flashMessages = []

  # Render flash messages immediately, not on next view load
  flashNow = (msg, type) ->
    $rootScope.flashMessages = buildFlashMessages(msg, type)

  # Add a message that will be displayed on next view load
  # types are 'error', and 'note'
  flash = (msg, type) ->
    flashMessages = flashMessages.concat(buildFlashMessages(msg, type))

  buildFlashMessages = (msg, type) ->
    messages = []
    if _.isArray(msg)
      messages.push({ msg: m, type: type }) for m in msg
    else
      messages.push({ msg: msg, type: type })
    return messages

  # render and clear flash messages
  $rootScope.$on '$viewContentLoaded', () ->
    $rootScope.flashMessages = flashMessages
    flashMessages = []

  return {
    flash: flash,
    flashNow: flashNow
  }

])
