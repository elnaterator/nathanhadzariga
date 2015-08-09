

app = angular.module 'App', []



app.controller 'AccountCtrl', ($scope, $http) ->
    $scope.accounts = []
    $http.get('/accounts.json').success (data)->
        console.log 'here'
        $scope.accounts = data