'use strict'


glob = require('glob')
_ = require('lodash')

cached = games: null

controller =

  # get all games
  query: (callback) ->
    if typeof callback isnt 'function'
      callback = ->

    if cached.games
      callback null, cached.games
    else
      # find in default games
      glob __dirname + '/../../../games/*/index.coffee', (err, files) ->
        if err
          return callback(err)
        else
          cached.games = {}
          for indexFile in files
            game = require(indexFile)
            gameId = indexFile.replace(/^.*\/([^\/]+)\/.*?$/, '$1')
            if typeof game.factory isnt 'function'
              console.log "[ERR] game '#{gameId}': factory function is not implemented."
            else if game.hidden
              console.log "[INFO] game '#{gameId}': game is hidden. (this game will not be shown to users."
            else
              copied = _.extend {}, game
              copied.options = {} unless copied.options
              copied.id = gameId
              copied.name = copied.name or gameId
              copied.template = "games/#{gameId}/#{copied.template}"
              if copied.image
                copied.image = "games/#{gameId}/#{copied.image}"
              cached.games[gameId] = copied

          # find in another project (submodule) http://yobi.navercorp.com/NAVER-HackDay/genius
          glob __dirname + '/../../../genius/*/index.coffee', (err, files) ->
            if err
              return callback(err)
            else
              for indexFile in files
                game = require(indexFile)
                gameId = indexFile.replace(/^.*\/([^\/]+)\/.*?$/, '$1')
                if typeof game.factory isnt 'function'
                  console.log "[ERR] game '#{gameId}': factory function is not implemented."
                else if game.hidden
                  console.log "[INFO] game '#{gameId}': game is hidden. (this game will not be shown to users."
                else
                  copied = _.extend {}, game
                  copied.options = {} unless copied.options
                  copied.id = gameId
                  copied.name = copied.name or gameId
                  copied.template = "genius/#{gameId}/#{copied.template}"
                  if copied.image
                    copied.image = "genius/#{gameId}/#{copied.image}"
                  cached.games[gameId] = copied
              callback null, cached.games
            return
        return
    return

  # get game by id
  get: (id, callback) ->
    if typeof callback isnt 'function'
      callback = ->

    @query (err, games) ->
      callback null, games[id]
      return
    return

controller.query()

module.exports = controller