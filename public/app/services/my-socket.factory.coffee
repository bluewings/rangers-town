'use strict'

angular.module 'rangers'
.factory 'mySocket', (socketFactory, $cookieStore, $state, $rootScope) ->
  token = $cookieStore.get 'token'
  if token
    ioSocket = io("?token=#{token}", path: '/socket.io')
    mySocket = socketFactory ioSocket: ioSocket  
  else
    mySocket = socketFactory()

  mySocket.stat = {}

  $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
    if toState.name is 'lounge' and mySocket.stat.me and mySocket.stat.rooms and mySocket.stat.rooms[mySocket.stat.me.room].name isnt 'lobby'
      for roomId, room of mySocket.stat.rooms
        if room.name is 'lobby'
          mySocket.emit 'room.join', room.id
          return
    return

  # lastRoom = {}

  setStat = ->
    return if !mySocket.stat.me or !mySocket.stat.rooms
    if mySocket.stat.me.room
      mySocket.stat.room = mySocket.stat.rooms[mySocket.stat.me.room]
    else
      mySocket.stat.room = null
    if mySocket.stat.room and mySocket.stat.room.clients and mySocket.stat.clients
      for id, dummy of mySocket.stat.room.clients
        if mySocket.stat.room.clients.hasOwnProperty id
          mySocket.stat.room.clients[id] = mySocket.stat.clients[id]

    for roomId, room of mySocket.stat.rooms
      for id, dummy of room.clients
        if room.clients.hasOwnProperty id
          room.clients[id] = mySocket.stat.clients[id]      

    # if mySocket.stat.rooms and mySocket.stat.me and mySocket.stat.me.room and mySocket.stat.rooms[mySocket.stat.me.room]
    #   currentRoom = mySocket.stat.rooms[mySocket.stat.me.room]

    #   if lastRoom.id isnt currentRoom.id
    #     if currentRoom.name is 'lobby'
    #       $state.go 'lounge'
    #     else
    #       $state.go "#{currentRoom.gameId}-game",
    #         roomId: currentRoom.id
    #     lastRoom = currentRoom




    return

  mySocket.on 'stat.me', (user) ->

    mySocket.stat.me = user
    mySocket.stat.room = mySocket.stat.me.room




    setStat()
    return

  mySocket.on 'stat.clients', (clients) ->
    # console.log 'stat.client!!!'
    # console.log clients
    mySocket.stat.clients = clients
    mySocket.stat.clientIdDict = {}
    for socketId, client of clients
      if client and client.profile and client.profile._id
        mySocket.stat.clientIdDict[client.profile._id] = true
    setStat()
    return

  mySocket.on 'stat.rooms', (rooms) ->
    # console.log rooms
    if rooms
      for id, room of rooms
        room.clientCount = Object.keys(room.clients).length
    mySocket.stat.rooms = rooms
    setStat()
    return

  mySocket