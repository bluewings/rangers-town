'use strict'

angular.module 'rangers'
.directive 'buttonLeave', ->
  restrict: 'A'
  controller: ($scope, $state, $element) ->  
    $element.on 'click', (event) ->
      $state.go 'lounge'
      return
    return