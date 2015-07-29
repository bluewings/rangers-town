'use strict'

angular.module 'rangers'
.directive 'backface', ->
  directive =
    restrict: 'C'
    template: '<canvas></canvas>'
    link: (scope, element, attrs) ->
      canvas = element.find('canvas').get(0)
      ctx = canvas.getContext '2d'
      canvas.width = element.width()
      canvas.height = element.height()
      ctx.strokeStyle = '#ddd'
      longer = Math.max(canvas.width, canvas.height)
      ctx.beginPath()
      for i in [0...longer * 2] by 10
        ctx.moveTo 0, i
        ctx.lineTo i, 0
        ctx.moveTo canvas.width, i
        ctx.lineTo canvas.width - i, 0
      ctx.closePath()
      ctx.stroke()
      return