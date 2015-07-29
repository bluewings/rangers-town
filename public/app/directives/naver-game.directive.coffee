'use strict'

angular.module 'rangers'
.directive 'naverGame', ->
  restrict: 'E'
  replace: true
  templateUrl: 'app/directives/naver-game.directive.html'
  scope: true
  bindToController: true
  controllerAs: 'vm'
  controller: ($scope, $element, resource) ->
    vm = @




    return