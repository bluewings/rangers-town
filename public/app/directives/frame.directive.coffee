'use strict'

angular.module 'rangers'
.directive 'frame', ->
  restrict: 'C'
  controller: ($scope, $element, $compile) ->
    inputMessage = $compile('<div class="player-message"><input-message></input-message></div>')($scope)
    $element.find('.player-me').append(inputMessage)
    return