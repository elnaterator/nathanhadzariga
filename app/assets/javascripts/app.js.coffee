angular.module('natesApp',[
  'ngRoute',
  'natesApp.auth',
  'natesApp.users',
  'natesApp.err'
  ])

# lodash integration
.run(['$rootScope', ($rootScope) ->
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
  .when('/manageusers', {
    templateUrl: '/template/users/users',
    controller: 'UsersCtrl'
  })

  #$locationProvider.html5Mode(true);

])
