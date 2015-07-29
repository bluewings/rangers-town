'use strict'

Friend = require('./friend.model')
User = require('../user/user.model')
onlineUsers = require('../user/user.online').users
config = require('../../config/environment')
_ = require('lodash')

validationError = (res, err) ->
  res.json 422, err

###*
Get list of friends
restriction: 'admin'
###
exports.index = (req, res) ->
  Friend.find {
    $or: [
      { uid1: req.user._id }
      { uid2: req.user._id }
    ]
  }
  .lean()
  .exec (err, friends) ->
    return res.send(500, err)  if err

    friendDict = {}
    ids = []
    userId = req.user._id.toString()
    for friend in friends
      cloned = {}
      _.extend cloned, friend
      # console.log cloned


      # console.log cloned.uid1, cloned.uid2, req.user._id
      if cloned.uid1 isnt userId
        cloned.friendId = cloned.uid1
      else if cloned.uid2 isnt userId
        cloned.friendId = cloned.uid2
      if cloned.friendId
        friendDict[cloned.friendId] = cloned
        ids.push cloned.friendId

    # console.log ids

    User.find
      _id: { $in: ids }
    .lean()
    .exec (err, users) ->
      newUsers = []
      for user, i in users
        if friendDict[user._id]
          friendDict[user._id].friend = user
          if onlineUsers[user._id]
            friendDict[user._id].online = onlineUsers[user._id]
          else
            friendDict[user._id].online = false
          newUsers.push friendDict[user._id]



      res.json 200, newUsers
    return

  return


###*
Creates a new friend
###
exports.create = (req, res, next) ->
  # 친구 관계는 양쪽 어디서든 연결할 수 있다.
  Friend.find {
    $or: [
      { uid1: req.params.id, uid2: req.user._id }
      { uid2: req.params.id, uid1: req.user._id }
    ]
  }, (err, friends) ->
    # 이미 존재하는 친구 관계

    return validationError(res, 'duplicated') if friends.length > 0
    
    newFriend = new Friend()
    newFriend.uid1 = req.user._id
    newFriend.uid2 = req.params.id
    newFriend.save (err, friend) ->
      return validationError(res, err) if err
      res.json newFriend
    return

  return


###*
Get a single friend
###
exports.show = (req, res, next) ->
  friendId = req.params.id
  Friend.findById friendId, (err, friend) ->
    return next(err)  if err
    return res.send(401)  unless friend
    res.json friend.profile
    return

  return


###*
Deletes a friend
restriction: 'admin'
###
exports.destroy = (req, res) ->

  # 친구 관계는 양쪽 어디서든 연결할 수 있다.
  Friend.find {
    $or: [
      { uid1: req.params.id }
      { uid2: req.params.id }
    ]
  }, (err, friends) ->
    for friend in friends
      friend.remove() 
    res.send 204
    
    return

  return

