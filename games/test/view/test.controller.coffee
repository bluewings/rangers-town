'use strict'

angular.module 'rangers'
.controller 'GameTestController', ($scope, $timeout, socket, me, stages, util, chat) ->  
  vm = @

  vm.me = me

  vm.data =
    players: []
    quiz: []
    state: ''

  socket.on 'sync', (data) ->
    vm.data = data
    return

  socket.emit 'request-sync'

  return