app = angular.module('homeApp',[])

app.controller 'welcomeCtrl', ($scope) ->
  $scope.name = 'Billson';

app.directive 'nhWelcome', ->
  { templateUrl: '/template/welcome' }
