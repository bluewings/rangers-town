'use strict'

App = {}

class App.Numbers
  constructor: (@socket) ->
    @state = 'ready'
    @gameNum = 1;
    @currUserSeq = 0;
    @players = []
    @addListener()

  reset: ->
    for player in @players
      player.reset()
    @gameNum = 1;
    @currUserSeq = 0;
    @calcSeq()

  addListener: ->
    my = @

    # 최초로 들어와서 데이터 sync 요청
    @socket.on 'request-sync', (sender) ->
      my.syncdata(sender)
      return

    # 게임 시작
    @socket.on 'start', (sender, message) ->
      my.start()
      return

    # 문제에 대답
    @socket.on 'answer', (sender, answer) ->
      if my.state isnt 'game'
        return;

      my.socket.emitTo sender, 'clear-answer'
      player = my.findPlayer(sender)
      console.log {'answer' : answer, 'pSeq' : player.seq, 'currUserSeq':my.currUserSeq}
      if my.currUserSeq is player.seq
        my.judge(player, answer)
      my.syncdata()

      return

  start: () ->
    my = @
    @reset()
    @state = 'game'
    @syncdata()
    console.log {'currUserSeq':@currUserSeq,'gameNum' : @gameNum}

  judge: (player, answer) ->
    gameNumStr = @gameNum.toString();
    if gameNumStr is ''
      player.msg = "ERROR"
      @state = 'gameend'
      @syncdata()
      return

    match = gameNumStr.match(/[3,6,9]/g);
    good = ''
    if match isnt null
      for cnt in [1..match.length]
        good += '#'
    else
      good = gameNumStr

    my = @
    console.log {good, answer}
    if good is answer
      player.msg = "O정답O"
      setTimeout ->
        player.msg = ""
        my.syncdata()
      , 1000
      @next()
    else
      player.msg = "X오답X \n 정답 : "+ good+" \n " + "입력된 답 : " + answer
      @state = 'gameend'
      setTimeout ->
        player.msg = ""
        my.syncdata()
      , 3000
    @syncdata()

  next: ->
    console.log '[NEXT]'
    @currUserSeq = (++@currUserSeq) % @players.length
    @gameNum++
    console.log {'gameAnswer' : @gameNum, 'curr': @currUserSeq,'mod':(@currUserSeq+1) % @players.length ,'plength':@players.length }
    @syncdata();

    return

  calcSeq: ->
    compareSeq = (a, b) ->
      return 0 if a.client.enterTm is a.client.enterTm
      if a.client.enterTm < b.client.enterTm
        return 1
      else
        return -1

    sortPlayers = []
    for player in @players
      sortPlayers.push player

    if sortPlayers.length isnt 1
      sortPlayers.sort compareSeq

    i = 0
    for player in sortPlayers
      player.seq = i++
    return

  syncdata: (sender)->
    syncdata =
      state: @state
      players: @players
      currUserSeq: @currUserSeq


    if sender
      @socket.emitTo sender, 'sync', syncdata
    else
      @socket.emit 'sync', syncdata
    return

  enter: (client) ->
    player = new App.Player(client)
    player.reset()
    @players.push player
    @calcSeq()
    @syncdata()
    return

  leave: (client) ->
    for player, i in @players
      if player.client.id is client.id
        @players.splice i, 1
        @syncdata()
        return
    return
  findPlayer: (client) ->
    for player in @players
      if player.client.id is client.id
        return player
    null

class App.Player
  constructor: (@client) ->
    @reset()

  reset: ->
    @score = 0
    @rank = 99
    @seq = 99
    @answer = ''
    @msg = ''

  resetMsg: ->
    @msg = ''

module.exports = App