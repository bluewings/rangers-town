'use strict'

socketioJwt = require('socketio-jwt')
config = require('../config/environment')
User = require('../api/user/user.model')
onlineUsers = require('../api/user/user.online').users
userControl = require('../api/user/user.controller')
gameControl = require('../api/game/game.controller')
resourceControl = require('../api/resource/resource.controller')
events = require('events')

module.exports = (io) ->
  systemSpeaker = '[GM]BROWN'

  emitMessage = (roomId, message, name, sender) ->
    io.to(roomId).emit 'message',
      sender: sender
      message: message
      name : name
      regTm: new Date()
    return

  generateUUID = ->
    d = (new Date).getTime()
    uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
      r = (d + Math.random() * 16) % 16 | 0
      d = Math.floor(d / 16)
      (if c == 'x' then r else r & 0x3 | 0x8).toString 16
    )
    uuid

  class SocketDelegate
    constructor: ->
  
  SocketDelegate.prototype = Object.create(events.EventEmitter.prototype)

  class Client
    constructor: (@id, @profile = {}, options = {}) ->
      @userAgent = options.userAgent
      @address = options.address
      @socket = -> options.socket
      @regTm = new Date()

  # 개별 게임 인스턴스에게 넘겨줄 클라이언트 인스턴스
  # 점수, 루비, 게임 데이터를 저장하는 함수가 필요하다.
  class ClientDelegate
    constructor: (client, roomInstance) ->
      @id = client.id
      @profile = client.profile
      @userAgent = client.userAgent
      @address = client.address
      @socket = client.socket
      @regTm = client.regTm
      @enterTm = new Date()
      @gameId = roomInstance.gameId

    getScore: (callback) ->
      userControl.getScore.call { gameId: @gameId }, @profile, callback
      return

    addScore: (numToAdd, callback) ->
      userControl.addScore.call { gameId: @gameId }, @profile, numToAdd, callback
      return

    getRuby: (callback) ->
      userControl.getRuby.call { gameId: @gameId }, @profile, callback
      return

    addRuby: (numToAdd, callback) ->
      userControl.addRuby.call { gameId: @gameId }, @profile, numToAdd, callback
      return

    subtractRuby: (numToSubtract, callback) ->
      userControl.subtractRuby.call { gameId: @gameId }, @profile, numToSubtract, callback
      return

    getGameData: (path, callback) ->
      userControl.getGameData.call { gameId: @gameId }, @profile, path, callback
      return

    setGameData: (path, value, callback) ->
      userControl.setGameData.call { gameId: @gameId }, @profile, path, value, callback
      return

    clearGameData: (path, callback) ->
      userControl.clearGameData.call { gameId: @gameId }, @profile, path, callback
      return


  class Room
    # constructor: (@name, game) ->
    constructor: (data = {}, game) ->
      my = @
      @id = generateUUID()
      unless data.name
        data.name = 'noname'
      @name = data.name
      if data.password
        @password = data.password
      @clients = {}
      @regTm = new Date()
      if game
        @gameId = game.id
        @gameName = game.name
        @gameImage = game.image
        if game.maxClients
          @maxClients = game.maxClients
        @socketDelegate = new SocketDelegate()
        limitedSocket = 
          emit: (eventName, message) ->
            args = ['__message__']
            for each in arguments
              args.push each
            context = io.to(my.id)
            context.emit.apply context, args
            return
          emitTo: (receivers, eventName, message) ->
            args = ['__message__']
            for each in arguments
              args.push each
            args.splice(1, 1)
            if Object::toString.call(receivers) isnt '[object Array]'
              receivers = [receivers]
            for receiver in receivers
              if my.clients[receiver.id] 
                client = clients.get(receiver.id)
                if client
                  context = client.socket()
                  context.emit.apply context, args
            return
          on: (eventName, callback) ->
            my.socketDelegate.on.apply my.socketDelegate, arguments
            return
        @instance = game.factory(limitedSocket, {
          options: data.options or {}
          clients: -> my.clients
          eject: my.leave
        }, resourceControl)

    join: (client) ->
      my = @
      if client.room and rooms.get(client.room)
        room = rooms.get(client.room)
        return if room.id is my.id
        room.leave client
      client.room = @id
      client.socket().join @id
      client.callback = (eventName, message) ->
        args = []
        for arg in arguments
          args.push arg
        args.splice(1, 0, client)
        if my.socketDelegate
          my.socketDelegate.emit.apply my.socketDelegate, args
        return
      client.socket().on '__message__', client.callback
      @clients[client.id] = true
      emitMessage @id, "@#{client.profile.name} has entered the #{@name}.", systemSpeaker
      if @instance and typeof @instance.onenter is 'function'

        #
        # HERE !!!
        #
        #
        clientDelegate = new ClientDelegate(client, @)

        @instance.onenter clientDelegate
      return

    leave: (client) ->
      if @instance and typeof @instance.onleave is 'function'

        clientDelegate = new ClientDelegate(client, @)

        @instance.onleave clientDelegate
      emitMessage @id, "@#{client.profile.name} has left the #{@name}.", systemSpeaker
      client.socket().leave @id
      if client.callback
        client.socket().removeListener '__message__', client.callback
        delete client.callback
      delete @clients[client.id]
      client.room = null
      return

  clients =
    _dict: {}
    add: (socket, profile) ->
      if socket and socket.id
        handshake = socket.handshake or {}
        handshake.headers = handshake.headers or {}
        client = new Client(socket.id, profile, {
          userAgent: handshake.headers['user-agent']
          address: handshake.address
          socket: socket
        })
        @_dict[client.id] = client
        return client
      return

    get: (clientId) ->
      return @_dict[clientId] if clientId
      @_dict

    remove: (clientId) ->
      if @_dict[clientId] and @_dict[clientId].room
        room = rooms.get @_dict[clientId].room
        if room
          room.leave @_dict[clientId]
      delete @_dict[clientId]
      return

  rooms = 
    _dict: {}
    add: (data, game) ->
      room = new Room(data, game)
      @_dict[room.id] = room
      room

    get: (roomId) ->
      return @_dict[roomId] if roomId
      avail = {}
      for key, value of @_dict
        if Object.keys(value.clients).length > 0
          avail[key] = value
      avail

  lobby = rooms.add { name: 'lobby' }

  io.use socketioJwt.authorize(
    secret: config.secrets.session
    handshake: true
  )

  io.on 'connection', (socket) ->

    User.findById socket.decoded_token._id, (err, user) ->
      return if err

      userControl.updateLastLoginTm(user._id)


      client = clients.add socket, user
      lobby.join client

      # 사용자 관리
      onlineUsers[user._id] =
        connected: new Date()
        location:
          gameId: 'lobby'
          roomId: lobby.id 

      console.log onlineUsers

      socket.emit 'stat.me', client
      io.emit 'stat.clients', clients.get()
      io.emit 'stat.rooms', rooms.get()

      # userControl.setListener user, (user) ->
      #   # # console.log '>>>>>'
      #   allClients = clients.get()
      #   # # console.log '>>> ' + user._id
      #   for clientId, each of allClients
      #     # # console.log each.profile
      #     if each.profile._id.toString() is user._id.toString()
      #       # # console.log '>>> '
      #       each.profile = user
      #     # # console.log client
      #   # client.profile = user
      #   socket.emit 'stat.me', client
      #   io.emit 'stat.clients', clients.get()      

      socket.on 'message', (message) ->
        client = clients.get socket.id
        if client.room
          emitMessage client.room, message, client.profile.name, client.id
        return

      socket.on 'room.create', (data = {}, fn = ->) ->
        client = clients.get socket.id
        gameControl.get data.gameId, (err, game) ->
          if err
            fn(err)
          else
            if game and game.factory
              room = rooms.add data, game
            else
              room = rooms.add data
            # room.join client
            socket.emit 'stat.me', client
            io.emit 'stat.clients', clients.get()
            io.emit 'stat.rooms', rooms.get()
            fn(null, room)
          return
        return

      # socket.on 'room.join', (roomId) ->
      socket.on 'room.join', (data = {}, fn = ->) ->
        client = clients.get socket.id
        if typeof data is 'string' and data is 'lobby'
          data = { roomId: lobby.id }
        if typeof data.roomId isnt 'string'
          fn('invalid request : ' + JSON.stringify(data))
          return
        room = rooms.get data.roomId

        if room and room.maxClients and room.maxClients <= Object.keys(room.clients).length

          fn('이미 꽉 찼음')

        else if room and room.gameId and room.gameId isnt data.gameId
          fn('gameId is not matched.')
        else if room and room.join
          room.join client


          # 방들어옴 (이동)
          if onlineUsers[user._id]
            onlineUsers[user._id].location =
              gameId: room.gameId
              roomId: room.id 

            console.log onlineUsers

          console.log onlineUsers

          socket.emit 'stat.me', client
          io.emit 'stat.clients', clients.get()
          io.emit 'stat.rooms', rooms.get()
          fn(null, room)
        else
          fn('room not found.')
        return

      socket.on 'room.leave', (roomId, fn = ->) ->
        client = clients.get socket.id
        if typeof roomId isnt 'string'
          fn('invalid request : ' + JSON.stringify(roomId))
          return
        room = rooms.get roomId

        if room
          room.leave client
          if room.name isnt 'lobby'
            lobby.join client
            room = lobby
            if onlineUsers[user._id]
              onlineUsers[user._id].location = 
                gameId: 'lobby'
                roomId: room.id
          else
            room = null
            if onlineUsers[user._id]
              onlineUsers[user._id].location = null

          console.log onlineUsers
          socket.emit 'stat.me', client
          io.emit 'stat.clients', clients.get()
          io.emit 'stat.rooms', rooms.get()
          fn(null, room)
        else
          fn('room not found.')
        return

      socket.on 'disconnect', ->
        clients.remove socket.id

        delete onlineUsers[user._id]

        io.emit 'stat.clients', clients.get()
        io.emit 'stat.rooms', rooms.get()
        return

      return

    return
