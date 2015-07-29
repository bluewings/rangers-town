'use strict'

App = {}

class App.Numbers
  constructor: (@socket) ->
    @state = 'ready'
    @quiz = []
    @players = []
    @lastWinner = null
    @addListener()

  reset: ->
    @quiz = []
    @lastWinner = null
    for player in @players
      player.reset()
    return

  addListener: ->
    my = @

    # 최초로 들어와서 데이터 sync 요청
    @socket.on 'request-sync', (sender) ->
      my.syncdata(sender)
      return

    # 게임 시작
    @socket.on 'start', (sender, message) ->
      my.start(10)
      return

    # 문제에 대답
    @socket.on 'answer', (sender, answer) ->
      player = my.findPlayer(sender)
      player.answer = answer
      if my.quiz
        for quiz in my.quiz
          if !quiz.hidden and !quiz.solved and answer.search(quiz.regexp) isnt -1
            quiz.solved = true
            quiz.winner = player
            player.score += 1
            player.answer = ''
            my.lastWinner = player
            my.socket.emitTo sender, 'clear-answer'
            my.calcRank()
            my.checkGameEnd()
            break
      my.syncdata()
      return

  start: (numOfQuiz = 10) ->
    my = @
    @reset()
    @state = 'game'
    for i in [0...numOfQuiz]
      num1 = parseInt(Math.random() * 40, 10) + 10
      num2 = parseInt(Math.random() * 40, 10) + 10
      @quiz.push
        uniq: 'u' + parseInt(Math.random() * 10000, 10)
        num1: num1
        num2: num2
        regexp: new RegExp(num1 + num2 + '$')
        solved: false
        hidden: true

    @syncdata()
    setTimeout ->
      my.openQuiz()
    , 1000

  openQuiz: ->
    my = @
    clearTimeout @timer
    unopened = []
    for quiz in @quiz
      if quiz.hidden
        unopened.push quiz
    if unopened.length > 0
      index = Math.floor(Math.random() * unopened.length)
      quiz = unopened.splice(index, 1)[0]
      quiz.hidden = false
      @syncdata()
      if unopened.length > 0
        @timer = setTimeout ->
          my.openQuiz()
        , 1500

  calcRank: ->
    compareScore = (a, b) ->
      return 0 if a.score is b.score
      if a.score < b.score
        return 1
      else 
        return -1 

    sortPlayers = []
    for player in @players
      sortPlayers.push player

    sortPlayers.sort compareScore

    i = 0
    sortPlayers.reduce (prev, curr) ->
      i++
      if prev.score is curr.score
        curr.rank = prev.rank
      else
        curr.rank = i
      return curr
    , {}

    return

  checkGameEnd: ->
    unsolved = 0

    for quiz in @quiz
      unless quiz.solved
        unsolved++

    if unsolved is 0
      @state = 'gameend'

    return

  syncdata: (sender)->
    syncdata = 
      state: @state
      players: @players
      lastWinner: @lastWinner
      quiz: @quiz

    if sender
      @socket.emitTo sender, 'sync', syncdata
    else
      @socket.emit 'sync', syncdata
    return

  enter: (client) ->
    player = new App.Player(client)
    @players.push player
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
    @answer = ''

module.exports = App