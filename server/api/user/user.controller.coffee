'use strict'

User = require('./user.model')
onlineUsers = require('./user.online').users
passport = require('passport')
config = require('../../config/environment')
jwt = require('jsonwebtoken')
glob = require('glob')

validationError = (res, err) ->
  res.json 422, err

listeners = {}

exports.setListener = (user, callback) ->
  # unless listeners[user._id]
  listeners[user._id] = 
    callback: callback

  # listeners[user._id].callback.push callback






# exports = {}
###*
Get list of users
restriction: 'admin'
###
exports.index = (req, res) ->
  User.find {}, '-salt -hashedPassword', (err, users) ->
    return res.send(500, err)  if err
    res.json 200, users
    return

  return


###*
Creates a new user
###
exports.create = (req, res, next) ->
  newUser = new User(req.body)
  newUser.provider = 'local'
  newUser.role = 'user'
  newUser.save (err, user) ->
    return validationError(res, err)  if err
    token = jwt.sign(
      _id: user._id
    , config.secrets.session,
      expiresInMinutes: 60 * 5
    )
    res.json token: token
    return

  return


###*
Get a single user
###
exports.show = (req, res, next) ->
  userId = req.params.id
  User.findById userId, (err, user) ->
    return next(err)  if err
    return res.send(401)  unless user
    res.json user.profile
    return

  return


###*
Deletes a user
restriction: 'admin'
###
exports.destroy = (req, res) ->
  User.findByIdAndRemove req.params.id, (err, user) ->
    return res.send(500, err)  if err
    res.send 204

  return


###*
Change a users password
###
exports.changePassword = (req, res, next) ->
  userId = req.user._id
  oldPass = String(req.body.oldPassword)
  newPass = String(req.body.newPassword)
  User.findById userId, (err, user) ->
    if user.authenticate(oldPass)
      user.password = newPass
      user.save (err) ->
        return validationError(res, err)  if err
        res.send 200
        return

    else
      res.send 403
    return

  return

###*
Change a users password
###
exports.update = (req, res, next) ->
  userId = req.user._id
  # oldPass = String(req.body.oldPassword)
  # newPass = String(req.body.newPassword)

  User.findById userId, (err, user) ->
    # if user.authenticate(oldPass)
    # user.password = newPass
    if req.body.character
      user.character = req.body.character  
    if req.body.name
      user.name = req.body.name
    if req.body.ruby
      user.ruby = req.body.ruby
    if req.body.score
      user.score = req.body.score
    user.save (err) ->
      return validationError(res, err)  if err


      if listeners[user._id] and listeners[user._id].callback
        # for each in listeners[user._id].callback
        listeners[user._id].callback(user)
      res.json user
      return

    # else
    #   res.send 403
    return

  return

exports.updateLastLoginTm = (userId) ->
  User.findById userId, (err, user) ->
    user.lastLoginTm = new Date()
    user.save()
    return
  return

###*
Get my info
###
exports.me = (req, res, next) ->
  userId = req.user._id
  User.findOne
    _id: userId
  , '-salt -hashedPassword', (err, user) -> # don't ever give out the password or salt
    return next(err)  if err
    return res.json(401)  unless user
    res.json user
    return

  return


###*
Authentication callback
###
exports.authCallback = (req, res, next) ->
  res.redirect '/'
  return


# path = require('path')

# chrs = ->

# console.log __dirname + '/../../../'
# console.log path.join(__dirname + '/../../../', 'public')

# console.log '>>> sync test'

###*
Get my info
###
exports.characters = (req, res, next) ->

  glob '../../../public/assets/rangers/*.png', (err, files) ->
    return next(err)  if err
    for file, i in files
      files[i] = file.replace(/^.*\//, '')
    res.json files
  

# server/api/socketio 의 client 에서 

exports.getScore = (user, callback) ->
  # @gameId 로 호출한 게임 정보를 알 수 있음
  return

exports.addScore = (user, numToAdd, callback) ->
  # @gameId 로 호출한 게임 정보를 알 수 있음
  return

exports.getRuby = (user, callback) ->
  # @gameId 로 호출한 게임 정보를 알 수 있음
  return

exports.addRuby = (user, numToAdd, callback) ->
  # @gameId 로 호출한 게임 정보를 알 수 있음
  return

exports.subtractRuby = (user, numToSubtract, callback) ->
  # @gameId 로 호출한 게임 정보를 알 수 있음
  return

exports.getGameData = (user = {}, path, callback) ->
  my = @

  if typeof path is 'function'
    callback = path
    path = []
  else if typeof path is 'string'
    path = path.split('.')

  if typeof callback isnt 'function'
    console.log 'reset callback'
    callback = ->

  User.findById user._id, (err, user) ->
    if err
      callback err
    else if !user
      callback null, {}
    else
      if !user.gameData or typeof user.gameData isnt 'object'
        user.gameData = {}
      if !user.gameData[my.gameId] or typeof user.gameData[my.gameId] isnt 'object'
        user.gameData[my.gameId] = {}

      data = user.gameData[my.gameId]
      for subPath in path
        if data isnt null and typeof data is 'object'
          data = data[subPath]
        else
          data = null
      callback null, data
    return
  return

# exports.setGameData = (user = {}, gameData = {}, callback = ->) ->
exports.setGameData = (user = {}, path, value, callback) ->
  my = @

  if typeof path is 'object'
    callback = value
    value = path
    path = "gameData.#{my.gameId}"
  else
    path = "gameData.#{my.gameId}.#{path}"

  if typeof callback isnt 'function'
    callback = ->

  set = {}
  set[path] = value
  
  User.update
    _id: user._id
  ,
    $set: set
  , (err) ->
    if err
      callback err
    else
      callback null, value
    return
  return