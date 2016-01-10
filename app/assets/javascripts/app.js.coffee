angular.module('natesApp',[
  'natesApp.users'
  ])
  
.run(['$rootScope', ($rootScope) -> # lodash on scope in views
  $rootScope._ = window._
])
