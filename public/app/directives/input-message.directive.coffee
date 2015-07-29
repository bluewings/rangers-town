'use strict'

angular.module 'rangers'
.directive 'inputMessage', ->
  restrict: 'E'
  replace: true
  templateUrl: 'app/directives/input-message.directive.html'
  scope: true
  bindToController: true
  controllerAs: 'vm'
  controller: ($scope, $element, mySocket, User) ->
    vm = @

    vm.sendMessage = ->
      if vm.message
        mySocket.emit 'message', vm.message, mySocket.stat.me.profile.name
        vm.message = ''
      return

    return
