'use strict'

angular.module 'rangers'
.controller 'GameTSNController', ($scope, $timeout, socket, me, stages, util, chat) ->
  vm = @
  vm.stage = stages[Math.floor(Math.random() * stages.length)]
  vm.badge = ''

  # chatting sample
  vm.messages = chat.messages
  vm.message = ''

  vm.submit = ->
    chat.send vm.message
    vm.message = ''
    return
  # //chatting sample


  vm.me = me

  vm.data =
    players: []
    state: ''
    currUserSeq: 0

  vm.check = ->
    socket.emit 'answer', vm.answer
    return

  vm.start = ->
    socket.emit 'start'
    return

  socket.emit 'request-sync'

  socket.on 'clear-answer', (data) ->
    vm.answer = ''
    return

  socket.on 'sync', (data) ->
    util.arrayMerge vm.data.players, data.players, 'client.id', true
    vm.data.currUserSeq = data.currUserSeq
    vm.data.state = data.state
    if vm.data.players
      for player in vm.data.players
        if player.seq is data.currUserSeq
          player.badge = 'light'
        else
          player.badge = ''
        if player.client.id is me.id
          vm.me_ = player
        if player.rank is 1
          player.rankStr = '1st'
        else if player.rank is 2
          player.rankStr = '2nd'
        else if player.rank is 3
          player.rankStr = '3rd'
        else
          player.rankStr = ''
    return

  return
.directive 'ngEnter', ->
  (scope, element, attrs) ->
    element.bind 'keydown keypress', (event) ->
      if event.which == 13
        scope.$apply ->
          scope.$eval attrs.ngEnter
        event.preventDefault()