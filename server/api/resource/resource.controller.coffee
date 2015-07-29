'use strict'

glob = require('glob')
sizeOf = require('image-size')

cached =
  rangers: null
  stages: null

getImageSize = (file) ->
  new Promise((resolve, reject) ->
    sizeOf file, (err, dimensions) ->
      if err
        resolve false
      else
        resolve dimensions
      return
  )

controller =

  # get stored character images
  getRangers: (callback) ->
    if typeof callback isnt 'function'
      callback = ->

    if cached.rangers
      callback(null, cached.rangers)
    else
      glob __dirname + '/../../../public/assets/rangers/*.png', (err, files) ->
        if err
          callback(err)
        else
          cached.rangers = []
          getImageSize = ->
            file = files.shift()
            sizeOf file, (err, dimensions) ->
              basename = file.replace(/^.*\//, '')
              if basename.search(/s\-leonard\-/) is -1
                cached.rangers.push
                  filename: basename
                  width: dimensions.width
                  height: dimensions.height
              if files.length > 0
                getImageSize()
              else
                callback(null, cached.rangers)
            return

          getImageSize()
          return
        return
    return

  # get stored stage images
  getStages: (callback) ->
    if typeof callback isnt 'function'
      callback = ->

    if cached.stages
      callback(null, cached.stages)
    else
      glob __dirname + '/../../../public/assets/stages/*.png', (err, files) ->
        if err
          callback(err)
        else
          cached.stages = []
          for file in files
            file = file.replace(/^.*\//, '')
            cached.stages.push file
          callback(null, cached.stages)
        return
    return

module.exports = controller
