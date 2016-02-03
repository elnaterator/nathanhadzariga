angular.module('natesApp',[
  'ngRoute',
  'natesApp.auth',
  'natesApp.manageUsers'
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
  .when('/profile', {
    templateUrl: '/template/auth/profile',
    controller: 'ProfileCtrl'
  })
  .when('/manageusers', {
    templateUrl: '/template/manage_users/manage_users',
    controller: 'ManageUsersCtrl'
  })
  .when('/blog', {
    templateUrl: '/template/blog/blog'
  })

  #$locationProvider.html5Mode(true);

])
