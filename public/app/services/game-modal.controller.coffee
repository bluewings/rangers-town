'use strict'

angular.module 'rangers'
.controller 'GameModalController', ($scope, $state, $modalInstance, mySocket, games, dictionary, user, util) ->
  vm = @
  vm.modalInstance = $modalInstance

  vm.name = util.pickOne(dictionary.adjective) + ' ' + user.name
  vm.games = games

  vm.game = util.pickOne vm.games



  vm.close = ->
    $modalInstance.dismiss()
    return

  vm.selectGame = (game) ->
    vm.game = game
    return

  $scope.$watch 'vm.game', (game) ->

    if util.isEmpty game.options
      vm.schema = null
      vm.form = []
    else
      vm.schema = 
        type: 'object'
        properties: game.options or {}
      vm.form = ['*']

    vm.options = {}

  vm.createGame = ->
    console.log 'create!!'
    if vm.game and vm.name
      console.log 'create 1!!'
      mySocket.emit 'room.create', 
        name: vm.name
        gameId: vm.game.id
        options: vm.options or {}
      , (err, room) ->
        if room
          $modalInstance.close()
          $state.go "#{room.gameId}-game",
            roomId: room.id
        else
          alert err
        return
      return

  return