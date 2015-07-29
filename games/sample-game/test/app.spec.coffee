App = require('../app')


socketMock = 
  emit: (eventName, message) ->
    return
  emitTo: (receivers, eventName, message) ->
    return
  on: (eventName, callback) ->
    return

clientMock = {} 

describe 'simple game test suite', ->

  numbers = null

  it 'create a new game', ->

    numbers = new App.Numbers(socketMock)
    # console.log numbers
    # game = new Game()
    # game.properties.players.length.should.equal(0)
    # game.properties.cards.length.should.equal(53)

  it 'add a player', ->
    # game.addPlayer new Player()
    # game.properties.players.length.should.equal(1)

  it 'leave a player', -> 

    # game.addPlayer new Player()
    # game.properties.players.length.should.equal(1)