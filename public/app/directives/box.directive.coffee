'use strict'

angular.module 'rangers'
.directive 'box', ->
  restrict: 'E'
  replace: true
  templateUrl: 'app/directives/box.directive.html'
  scope: true
  bindToController: true
  controllerAs: 'vm'
  controller: ($scope, $element, $timeout, resource) ->
    vm = @

    console.log colorbrewer
    vm.colorbrewer = colorbrewer.YlGn['9']
    console.log vm.colorbrewer

    shuffle = (array) ->
      m = array.length
      # While there remain elements to shuffle…
      while m
        # Pick a remaining element…
        i = Math.floor(Math.random() * m--)
        # And swap it with the current element.
        t = array[m]
        array[m] = array[i]
        array[i] = t
      array

    resource.rangers.then (rangers) ->
      vm.rangers = shuffle(rangers).splice(0, 18)
      return

      console.log vm.rangers

    $timeout ->
      vm.animate = true
      true

    return