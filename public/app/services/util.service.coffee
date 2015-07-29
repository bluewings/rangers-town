'use strict'

app = angular.module 'rangers'
.service 'util', ->

  # Speed up calls to hasOwnProperty
  hasOwnProperty = Object::hasOwnProperty

  setPlayerIndex = (players, me) ->
    myIndex = getMyIndex players, me
    for player, i in players
      idx1 = i - myIndex
      if idx1 < 0
        idx2 = idx1 + players.length
      else
        idx2 = idx1 - players.length
      if Math.abs(idx1) > Math.abs(idx2)
        idx = idx2
      else if Math.abs(idx1) < Math.abs(idx2)
        idx = idx1
      else if idx1 > idx2
        idx = idx1
      else
        idx = idx2
      player._index = idx
    players

  getMyIndex = (players, me) ->
    for player, i in players
      if player.client and player.client.id is me.id
        return i
    null

  isEmpty = (obj) ->
    # null and undefined are "empty"
    if obj == null
      return true
    # Assume if it has a length property with a non-zero value
    # that that property is correct.
    if obj.length > 0
      return false
    if obj.length == 0
      return true
    # Otherwise, does it have any properties of its own?
    # Note that this doesn't handle
    # toString and valueOf enumeration bugs in IE < 9
    for key of obj
      if hasOwnProperty.call(obj, key)
        return false
    true

  # http://bost.ocks.org/mike/shuffle/
  shuffleArray = (array) ->
    m = array.length
    # While there remain elements to shuffle…
    while m
      # Pick a remaining element…
      i = Math.floor(Math.random() * m--)
      # And swap it with the current element.
      t = array[m]
      array[m] = array[i]
      array[i] = t
    array

  pickOne = (array) ->
    array[Math.floor(Math.random() * array.length)]



  getValue = (data, path) ->
    paths = path.split('.')
    paths.reduce ((data, path) ->
      if data == null or data == undefined or typeof data isnt 'object'
        return null
      else if data[path] == undefined
        return null
      data[path]
    ), data

  arrayMerge = (source, data, key, removeUnmatched) ->
    return if !source or !data
    dict = {}
    for each in source
      dict[getValue(each, key)] = each
    for each in data
      if dict[getValue(each, key)]
        origin = dict[getValue(each, key)] 
        for sKey of each
          if each.hasOwnProperty(sKey)
            origin[sKey] = each[sKey]
        delete dict[getValue(each, key)]
      else
        source.push each
    if removeUnmatched
      i = source.length - 1
      while i >= 0
        each = source[i]
        if dict[getValue(each, key)]
          source.splice i, 1
        i--
    return

  util = 
    setPlayerIndex: setPlayerIndex
    getMyIndex: getMyIndex
    isEmpty: isEmpty
    shuffleArray: shuffleArray
    pickOne: pickOne
    getValue: getValue
    arrayMerge: arrayMerge