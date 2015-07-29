'use strict'

express = require('express')
game = require('./game.controller')
router = express.Router()

router.get '/', (req, res, next) ->
  game.query (err, games) ->
    if err
      next err
    else
      arr = []
      Object.keys(games).forEach (key) ->
        arr.push games[key]
        return
      output = []
      if req.query and req.query.global
        req.query.global = req.query.global.replace(/[^a-zA-Z0-9]/g, '')
        output.push "var #{req.query.global} = "
      output.push JSON.stringify(arr)
      res.send output.join('')
    return
  return
module.exports = router