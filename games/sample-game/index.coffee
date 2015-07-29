'use strict'

App = require('./app')

module.exports =
  hidden: false
  author: 'darth.vader@navercorp.com'
  name: '덧셈 게임'
  image: 'view/assets/sample-plus.PNG'
  template: 'view/sample.controller.html'
  controller: 'GameSampleController'
  options: {
    desc: '게임 준.비.완료~! Rangers-town의 오리지날 샘플 게임! 누가 가장 빨리 덧셈을 할까요? 팀원들과 경쟁해볼까요?'    
  }
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