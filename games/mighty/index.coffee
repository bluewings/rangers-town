'use strict'

App = require('./app')

module.exports =
  hidden: false
  author: 'darth.vader@navercorp.com'
  name: ' 마이티'
  # image: 'view/assets/sample-plus.PNG'
  template: 'view/mighty.controller.html'
  controller: 'GameMightyController'
  options: {
    desc: '전설의 마이티, 온라인으로 돌아왔다!'
  }
  factory: (socket, roomAPI, resource) ->

    mighty = new App.Mighty(socket, roomAPI, resource)

    instance =
      onenter: (client) ->
        mighty.enter client
        return
      
      onleave: (client) ->
        mighty.leave client
        return    

    instance