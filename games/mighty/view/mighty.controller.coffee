'use strict'

angular.module 'rangers'
.controller 'GameMightyController', ($scope, $timeout, socket, me, stages, util, chat) ->  
  vm = @

  vm.stage = stages[Math.floor(Math.random() * stages.length)]


  # chatting sample
  vm.messages = chat.messages
  vm.message = ''

  vm.submit = ->
    chat.send vm.message
    vm.message = ''
    return
  # //chatting sample

  # alert 'aaa'

  vm.me = me



  vm.data =
    players: []
    quiz: []
    state: ''

  vm.kick = (player) ->
    socket.emit 'kick', player
    # vm.answer = ''
    return

  vm.checkEnter = (event) ->
    if event.keyCode is 13
      socket.emit 'answer', vm.answer
      vm.answer = ''
    return

  vm.check = ->
    socket.emit 'answer', vm.answer
    return

  vm.addP = ->
    socket.emit 'add-p'
    return

  vm.removeP = ->
    socket.emit 'remove-p'
    return


  vm.start = ->
    socket.emit 'start'
    return

  socket.emit 'request-sync'

  socket.on 'clear-answer', (data) ->
    vm.answer = ''
    return

  # console.log 'asaa'

  socket.on 'sync', (data) ->
    # util.arrayMerge vm.data.players, data.players, 'client.id', true
    util.arrayMerge vm.data.players, data.players, '_id', true

    console.log data.players.length
    util.arrayMerge vm.data.quiz, data.quiz, 'uniq', true
    console.log data
    vm.data.lastWinner = data.lastWinner
    vm.data.state = data.state
    vm.data.myIndex = util.getMyIndex(vm.data.players, vm.me)
    util.setPlayerIndex(vm.data.players, vm.me)
    return

  return