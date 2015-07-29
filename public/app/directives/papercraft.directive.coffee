'use strict'

angular.module 'rangers'
.directive 'papercraft', ->
  restrict: 'E'
  replace: true
  templateUrl: 'app/directives/papercraft.directive.html'
  scope:
    user: '=user'
  bindToController: true
  controllerAs: 'vm'
  controller: ($scope, $element, $window, $document, resource) ->
    vm = @


    # 임한울 : u133-sally-thum-140.png
    # 정가영 : u292e-baigo-thum-140.png
    # 함돈범 : u020e-brown-thum-140.png

    console.log vm.user

    unless vm.user

      resource.rangers.then (rangers) ->
        vm.user =
          character: rangers[Math.floor(Math.random() * rangers.length)].filename
        # vm.user =
        #   character: 'u133-sally-thum-140.png'

    return
