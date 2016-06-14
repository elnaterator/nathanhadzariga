angular.module('natesApp',[
  'ngRoute',
  'natesApp.auth',
  'natesApp.manageUsers',
  'natesApp.blog',
  'natesApp.nav',
  'natesApp.profile'
  ])

.run(['$rootScope', '$location', 'AuthSrvc', ($rootScope, $location, AuthSrvc) ->

  # lodash integration
  $rootScope._ = window._
  flashMessages = []
  $rootScope.flashMessages = []

  # initialization
  if AuthSrvc.isLoggedIn()
    # refresh token
  else if AuthSrvc.getToken() && AuthSrvc.isTokenExpired()
    # nav to login page
    $location.path('/login')
    # clear token
    AuthSrvc.setToken(null)
  else
    # clear token (just in case)
    AuthSrvc.setToken(null)

  #
  # Flash message handling
  #

  # Render flash messages immediately, not on next view load
  $rootScope.flashNow = (msg, type) ->
    $rootScope.flashMessages = buildFlashMessages(msg, type)

  # Add a message that will be displayed on next view load
  # types are 'error', and 'note'
  $rootScope.flash = (msg, type) ->
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

  #
  # Global event handling
  #

  # nav to login page for an unauthorized response
  $rootScope.$on 'response:unauthorized', () ->
    $location.path('/login')
    $rootScope.flash('Please login again to continue using this website.', 'note')

])

.config(['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->

  $routeProvider
  .when('/', {
    templateUrl: '/template/home'
  })
  .when('/login', {
    templateUrl: '/template/auth/login',
    controller: 'AuthCtrl'
  })
  .when('/profile', {
    templateUrl: '/template/auth/profile',
    controller: 'ProfileCtrl'
  })
  .when('/blog', {
    templateUrl: '/template/blog/blog',
    controller: 'BlogCtrl'
  })
  .when('/dashboard', {
    templateUrl: '/template/dashboard'
  })

  #$locationProvider.html5Mode(true);

])
