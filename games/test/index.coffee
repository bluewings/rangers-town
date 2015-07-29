'use strict'

App = require('./app')

module.exports =
  hidden: true
  author: 'darth.vader@navercorp.com'
  name: 'platform test'
  template: 'view/test.controller.html'
  controller: 'GameTestController'
  factory: (socket, roomAPI, resource) ->

    numbers = new App.Numbers(socket)

    instance =
      onenter: (client) ->

        console.log '>> client on enter'
        
        numbers.enter client
        return
      
      onleave: (client) ->
        numbers.leave client
        return    

    instance