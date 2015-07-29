'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema

FriendSchema = new Schema(
  uid1: String
  uid2: String
)

module.exports = mongoose.model('Friend', FriendSchema)