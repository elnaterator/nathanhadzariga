angular.module('natesApp',[
  'ngRoute',
  'natesApp.auth',
  'natesApp.manageUsers',
  'natesApp.blog'
  ])

.run(['$rootScope', ($rootScope) ->

  # lodash integration
  $rootScope._ = window._

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
