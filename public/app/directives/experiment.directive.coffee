'use strict'

angular.module 'rangers'
.directive 'experiment', ->
  restrict: 'E'
  replace: true
  templateUrl: 'app/directives/experiment.directive.html'
  scope: true
  bindToController: true
  controllerAs: 'vm'
  controller: ($scope, $element, resource) ->
    vm = @

    canvas = $element.find('canvas')[0]
    ctx = canvas.getContext('2d')

    resource.rangers.then (rangers) ->
      vm.ranger = rangers[Math.floor(Math.random() * rangers.length)]
      return

    extractEdge = (img) ->
      canvas.width = img.width * 2+ 20
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
      dat = 1
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
          # console.log 'skip'
          continue
        else
          dict3[key] = va

      ctx.drawImage img, 0, 0, img.width, img.height,  img.width + x , y, w, h


      lines = []
      for key, va of dict3
        ctx.fillStyle = 'black'
        # console.log va.x * dat, va.y * dat
        # ctx.fillRect va.x * dat + x, va.y * dat + y, dat - 2, dat - 2
        ctx.translate va.x * dat + x, va.y * dat + y 
        # ctx.fillRect va.x * dat + x, va.y * dat + y, dat - 2, dat - 2
        # ctx.rotate 
        degree = 0
        ctx.rotate(degree*Math.PI/180)
        # ctx.fillStyle = 'rgba(0,0,0,.2)'
        # ctx.fillRect 0, 0 , dat - 2, dat - 2
        # ctx.fillRect 0, 0 , dat * 1.5, dat * 1.5
        # ctx.fillRect 0, 0 , dat * 1, dat * 1
        ctx.rotate(-degree*Math.PI/180)
        ctx.translate -(va.x * dat + x), -(va.y * dat + y)
        lines.push va
        # ctx.beginPath();
        # ctx.arc( va.x * dat + x, va.y * dat + y, Math.floor(dat / 2) - 2,0,2*Math.PI);
        # ctx.fillStyle = 'rgba(0,0,0,.5)'
        # ctx.fill();


      # console.log dict3
      console.log Object.keys(dict3).length
      # console.log lines
      series = [lines.shift()]
      j = 0
      while lines.length > 0 and j < 1000
        dot = series[series.length - 1]
        closest = obj: null, dist: 9999
        for other in lines
          distance = Math.pow(dot.x - other.x, 2) + Math.pow(dot.y - other.y, 2)
          if distance < closest.dist
            closest.obj = other
            closest.dist = distance


          # console.log distance, closest
          # console.log dot
        j++

        for other, i in lines
          if other is closest.obj
            next = lines.splice(i, 1)[0]
            series.push next
            break


        
      console.log 'iteration cnt ' + j
      console.log 'series'
      console.log series
      draw = ->
        now = series.pop()

        if now
          ctx.fillRect now.x, now.y, 1, 1
          setTimeout draw, 10


      pathes = []
      draw2 = ->
        i = 0
        start = series[0]
        ctx.beginPath()
        series.reduce (prev, curr) ->
          if i % 10 is 0
            pathes.push curr
            if i is 0
              ctx.moveTo curr.x, curr.y
            else
              ctx.lineTo curr.x, curr.y


          i++
        , null
        ctx.lineTo start.x, start.y
        ctx.lineWidth = 2
        ctx.lineCap = 'round'
        ctx.lineJoin = 'round'
        ctx.strokeStyle = 'gray'
        # ctx.stroke()
        pattern = Trianglify({
          height: w
          width: h
          cell_size: 20
        })
        ctx.clip()
        ctx.drawImage pattern.canvas(), 0, 0, w, h


        # document.body.appendChild(pattern.canvas());
        console.log pathes.length

      ctx.translate 10.5, 10.5

      
      # ctx.drawImage img, 0, 0, img.width, img.height,  0 , 0, w, h  
      draw2()
      


      # draw()



      # for dot in lines

      #   for each in lines



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