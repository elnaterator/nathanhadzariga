angular.module('natesApp',[
  'ngRoute',
  'natesApp.auth',
  'natesApp.manageUsers',
  'natesApp.blog'
  ])

.run(['$rootScope', '$location', 'AuthSrvc', ($rootScope, $location, AuthSrvc) ->

  # lodash integration
  $rootScope._ = window._

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

])

.config(['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->

  $routeProvider
  .when('/', {
    templateUrl: '/template/home'
  })
  .when('/login', {
    templateUrl: '/template/auth/login',
    controller: 'LoginCtrl'
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
