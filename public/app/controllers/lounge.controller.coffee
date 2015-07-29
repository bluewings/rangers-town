'use strict'

angular.module 'rangers'
.controller 'LoungeController', ($scope, $state, $element, mySocket, Game, friends, Friend) ->  
  vm = @

  # vm.games = games
  vm.socketStat = mySocket.stat

  #console.log mySocket.stat

  vm.messages = []


  vm.friendLinks = friends

  vm.newGame = ->
    Game.modal()

  # vm.createRoom = (game) ->
  #   mySocket.emit 'room.create', 
  #     name: Math.random()
  #     gameId: game.id
  #   , (err, room) ->
  #     if room
  #       $state.go "#{room.gameId}-game",
  #         roomId: room.id
  #     return
  #   return

  # vm.joinRoom = (room) ->      
  #   mySocket.emit 'room.join', room.id
  #   return

  vm.sendMessage = ->
    if vm.message
      mySocket.emit 'message', vm.message, mySocket.stat.me.profile.name
      vm.message = ''
    return
    
  vm.getRoom = (roomId) ->
    if mySocket && mySocket.stat && mySocket.stat.rooms[roomId] isnt null
      return mySocket.stat.rooms[roomId]
    return ''

  mySocket.on 'message', (message) ->
    vm.messages.push message
    messages = $element.find('.messages')
    lists = $element.find('.messages ul')
    if lists.outerHeight() - messages.scrollTop() <= messages.innerHeight()
      setTimeout ->
        messages.stop().animate
          scrollTop: lists.outerHeight() 
        return
      , 10
    return

  return