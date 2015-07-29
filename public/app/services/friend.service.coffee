'use strict'

app = angular.module 'rangers'

app.factory 'Friend', ($resource, $interval) ->
  Friend = $resource '/api/friends/:id/:controller',
    id: '@uid2'

  Friend.updateFriends = ->
    unless Friend.cache
      Friend.cache = {}

    Friend.query (friends) ->
      Friend.cache.dict = {}
      Friend.cache.linkDict = {}
      for link in friends
        if link.friendId
          Friend.cache.dict[link.friendId] = link.friend
          Friend.cache.linkDict[link.friendId] = link
      return
    return

  Friend.updateFriends()

  $interval ->
    Friend.updateFriends()
  , 60 * 1000
  

  Friend
