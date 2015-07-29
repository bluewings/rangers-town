'use strict'

App = require('./app')

module.exports =
  hidden: true
  author: 'donbum.ham@navercorp.com'
  name: '무언의 369'
  template: 'view/tsn.controller.html'
  controller: 'GameTSNController'
  factory: (socket, roomAPI, resource) ->

    numbers = new App.Numbers(socket)

    instance =
      onenter: (client) ->
        numbers.enter client
        return
      
      onleave: (client) ->
        numbers.leave client
        return    

    instance