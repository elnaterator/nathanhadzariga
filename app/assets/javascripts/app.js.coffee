angular.module('natesApp',[
  'ngRoute',
  'natesApp.auth',
  'natesApp.users'
  ])

.run(['$rootScope', ($rootScope) -> # lodash on scope in views
  $rootScope._ = window._
])

.config(['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->

  $routeProvider

  .when('/', {
    templateUrl: '/template/welcome'
  })

  .when('/login', {
    templateUrl: '/template/login',
    controller: 'LoginCtrl'
  })

  .when('/manageusers', {
    templateUrl: '/template/users',
    controller: 'UsersCtrl'
  })

  $locationProvider.html5Mode(true);

])
