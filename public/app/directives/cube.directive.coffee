'use strict'

angular.module 'rangers'
.directive 'cube', ->
  restrict: 'E'
  replace: true
  templateUrl: 'app/directives/cube.directive.html'
  scope: true
  bindToController: true
  controllerAs: 'vm'
  controller: ($scope, $element, resource) ->
    vm = @

    return

    canvas = $element.find('canvas')[0]
    ctx = canvas.getContext('2d')

    resource.rangers.then (rangers) ->
      vm.ranger = rangers[Math.floor(Math.random() * rangers.length)]
      return

    extractEdge = (img) ->
      canvas.width = img.width + 20
      canvas.height = img.height + 20
      x = 10
      y = 10
      w = img.width
      h = img.height
      ctx.drawImage img, 0, 0, img.width, img.height, x, y, w, h
      imageData = ctx.getImageData(x, y, w, h)
      data = imageData.data
      i = 0
      dict = {}
      dict2 = {}
      dots = []
      dat = 15
      while i < data.length
        _x = Math.floor(i / 4) % w
        _y = ((i / 4) - _x) / w      
        key = _x + '.' + _y
        dict[key] =
          r: data[i]
          g: data[i + 1]
          b: data[i + 2]
          a: data[i + 3]
        
        if _x % dat isnt 0 or _y % dat isnt 0
          data[i + 3] = 0
        else if _y > h * .67 and data[i + 3] < 100 and data[i] is 0 and data[i + 1] is 0 and data[i + 2] is 0
          data[i + 3] = 0
        else
          if data[i + 3] > 200
            dots.push [_x, _y, dat, data[i], data[i + 1], data[i + 2]]
            key2 = (_x / dat) + '.' + (_y / dat)
            dict2[key2] =
              x: (_x / dat)
              y: (_y / dat)
              r: data[i]
              g: data[i + 1]
              b: data[i + 2]
              a: data[i + 3]
          data[i] = 0
          data[i + 1] = 0
          data[i + 2] = 0
        
        i += 4
      # console.log dict
      # ctx.putImageData imageData, x, y
      ctx.translate .5, .5
      ctx.clearRect 0, 0, canvas.width, canvas.height

      # for each in dots
      #   ctx.fillStyle = "rgb(#{each[3]}, #{each[4]}, #{each[5]})"
      #   # console.log "rgb(#{each[3]}, #{each[4]}, #{each[5]})"
      #   ctx.fillRect each[0], each[1], each[2] - 2, each[2] - 2
      #   ctx.strokeRect each[0], each[1], each[2] - 2, each[2] - 2
      # console.log dict2

      dict3 = {}
      for key, va of dict2
        if dict2[(va.x - 0) + '.' + (va.y - 1)] and dict2[(va.x + 1) + '.' + (va.y + 0)] and dict2[(va.x - 0) + '.' + (va.y + 1)] and dict2[(va.x - 1) + '.' + (va.y + 0)]
          console.log 'skip'
        else
          dict3[key] = va

      ctx.drawImage img, 0, 0, img.width, img.height, x, y, w, h


      for key, va of dict3
        ctx.fillStyle = 'black'
        console.log va.x * dat, va.y * dat
        ctx.fillRect va.x * dat + x, va.y * dat + y, dat - 2, dat - 2

      # console.log dict3

      return
      


    $scope.$watch 'vm.ranger', (ranger) ->
      if ranger
        img = document.createElement 'IMG'
        img.onload = ->
          extractEdge(img)
          return
        img.src = "/assets/rangers/#{vm.ranger}"
      return

    return