'use strict'

angular.module 'rangers'
.directive 'prototype', ->
  restrict: 'E'
  replace: true
  templateUrl: 'app/directives/prototype.directive.html'
  scope: true
  bindToController: true
  controllerAs: 'vm'
  controller: ($scope, $element, $window, util, $document, frameUtil) ->
    vm = @

    # canvas = $element.find('canvas').get(0)
    # ctx = canvas.getContext('2d')

    randomPlayer = ->
      player =
        client:
          id: Math.floor(Math.random() * 1000000)

    vm.players = [
      randomPlayer()
      randomPlayer()
      randomPlayer()
      randomPlayer()
      randomPlayer()
    ]

    vm.me = vm.players[Math.floor(Math.random() * vm.players.length)].client

    vm.myIndex = util.getMyIndex(vm.players, vm.me)
    util.setPlayerIndex(vm.players, vm.me)

    setPlayerPosition = (players, me) ->

      # myIndex = util.getMyIndex(players, me)
      util.setPlayerIndex(players, me)      
      for player in players
        if player.client.id isnt me.id
          position = frameUtil.getPosition(players.length, player._index)
          console.log position
          player._position = position



    
    setPlayerPosition(vm.players, vm.me)

    # frameUtil.getPosition(5, 1)
    # frameUtil.getPosition(5, 2)
    # frameUtil.getPosition(5, -2)
    # frameUtil.getPosition(5, -1)

    return

    vm.p1 = 
      character: 'u200e-at-32d-thum-140.png'

    vm.p2 = 
      character: 'u109e-edward-thum-140.png'

    vm.p3 = 
      character: 'u092e-honey-thum-140.png'


    vm.p4 = 
      character: 'u123e-brown-thum-140.png'


    vm.me = 
      character: 'u099e-alice-thum-140.png'
    resizeHandler = ->
      return
      canvas.width = window.innerWidth
      canvas.height = window.innerHeight
      ctx.clearRect 0, 0, canvas.width, canvas.height

      pad = 50

      xMid = canvas.width / 2
      yMid = canvas.height / 2

      # ctx.moveTo xMid, pad
      # ctx.bezierCurveTo (xMid + canvas.width - pad) / 2, pad,
      #   canvas.width - pad, (pad + yMid) / 2,
      #   canvas.width - pad, yMid
      # ctx.stroke()


      return

    $($window).on 'resize', (event) ->
      resizeHandler()
      return

    resizeHandler()




    vm.updateBackground = ->

      return
      pattern = Trianglify({
        width: window.innerWidth
        height: window.innerHeight
        x_colors: 'Spectral'
        # x_colors: 'YlGnBu'
      })
      # return
      # $element.find('.background').append pattern.canvas()
      $document.find('body').css
        background: 'url(' + pattern.canvas().toDataURL() + ')'
        backgroundSize: 'cover'
        backgroundPosition: '50% 0'
      console.log 'background set'
      return

    vm.updateBackground()
    
    return
