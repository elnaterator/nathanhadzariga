angular.module('natesApp')

.directive('natesEnter', () ->
  {
    restrict: 'A',
    link: (scope, element, attributes) ->
      element.bind("keypress", (event) ->
        if(event.which == 13)
          scope.$apply () ->
            scope.$eval(attributes.natesEnter)
          event.preventDefault()
      )
  }
)
