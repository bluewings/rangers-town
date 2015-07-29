'use strict'

express = require('express')
path = require('path')
favicon = require('serve-favicon')
morgan = require('morgan')
compression = require('compression')
bodyParser = require('body-parser')
methodOverride = require('method-override')
cookieParser = require('cookie-parser')
session = require('express-session')
errorHandler = require('errorhandler')
config = require('./environment')
passport = require('passport')

module.exports = (app) ->
  env = app.get('env')
  app.set 'views', config.root + '/server/views'
  app.set 'view engine', 'jade'
  app.locals.pretty = true

  app.use compression()
  app.use bodyParser.urlencoded(extended: false)
  app.use bodyParser.json()
  app.use methodOverride()
  app.use cookieParser(config.secrets.session)
  app.use session(
    secret: config.secrets.session
    resave: true
    saveUninitialized: true
  )
  app.use passport.initialize()
  app.use passport.session()

  if 'production' is env
    app.use favicon(path.join(config.root, 'public', 'favicon.ico'))
    app.use express['static'](path.join(config.root, 'public'))
    app.set 'appPath', config.root + '/public'
    app.use morgan('dev')
  if 'development' is env or 'test' is env
    app.use express['static'](path.join(config.root, '.tmp'))
    app.use express['static'](path.join(config.root, 'public'))
    app.use '/games', express['static'](path.join(config.root, 'games'))
    app.use '/genius', express['static'](path.join(config.root, 'genius'))
    app.set 'appPath', 'client'
    app.use morgan('dev')
    app.use errorHandler()
  return
