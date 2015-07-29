'use strict'

module.exports = (app) ->

  # Insert routes below
  app.use '/api/games', require('./api/game')
  app.use '/api/users', require('./api/user')
  app.use '/api/friends', require('./api/friend')
  app.use '/api/resources', require('./api/resource')
  app.use '/auth', require('./auth')

  return
