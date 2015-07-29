'use strict'

angular.module 'rangers'
.directive 'player', ->
  restrict: 'C'
  link: (scope, element, attrs) ->
    return