'use strict'

angular.module 'rangers'
.directive 'figureBox', ->
  restrict: 'A'
  replace: false
  templateUrl: 'app/directives/figure-box.directive.html'
  scope: true
  bindToController: true
  controllerAs: 'vm'
  controller: ($scope, $element, resource) ->
    vm = @

    return
