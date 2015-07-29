'use strict'

angular.module 'rangers'
.directive 'wordArt', ->
  restrict: 'E'
  transclude: true
  templateUrl: 'app/directives/word-art.directive.html'
  scope:
    text: '@text'
    width: '='
    height: '='
    _options: '=options'
  bindToController: true
  controllerAs: 'vm'
  controller: ($scope, $element, $attrs, $timeout) ->
    vm = @

    doc = $(document)
    elems = {}
    elems.previewCanvas = $element.find('.preview-wrap canvas').get(0)
    elems.previewCtx = elems.previewCanvas.getContext '2d'

    vm.options =
      snapToGrid: true
      unit: 20
      letterSpacing: 1
      textBaseline: 'hanging'
      maxFontSize: 48


    $scope.$watch 'vm._options', (options) ->
      if options
        console.log '>>>'
        for key of options
          if options.hasOwnProperty(key)
            vm.options[key] = options[key]
    , true

    vm.points = [
      { x: 20, y: 260 }
      { x: 120, y: 20 }
      { x: 280, y: 260 }
      { x: 460, y: 180 }
    ]
    vm.points = [
      {
        "x": 0,
        "y": 240
      },
      {
        "x": 120,
        "y": 100
      },
      {
        "x": 360,
        "y": 100
      },
      {
        "x": 480,
        "y": 240
      }
    ]    
    vm.points = [
      {
        "x": 40,
        "y": 140
      },
      {
        "x": 160,
        "y": 100
      },
      {
        "x": 280,
        "y": 180
      },
      {
        "x": 400,
        "y": 140,
        "radian": null
      }
    ]
    renderPreview = ->
      pts = vm.points
      canvas = elems.previewCanvas
      ctx = elems.previewCtx
      canvas.width = vm.width
      canvas.height = vm.height
      ctx.clearRect 0, 0, canvas.width, canvas.height
      if vm.options.showGuide
        ctx.beginPath()

        x = 0
        while x < canvas.width
          ctx.moveTo x, 0
          ctx.lineTo x, canvas.height
          x += vm.options.unit
        y = 0
        while y < canvas.height
          ctx.moveTo 0, y
          ctx.lineTo canvas.width, y
          y += vm.options.unit
        ctx.strokeStyle = '#ddd'
        ctx.stroke()
        ctx.closePath()
      render(vm.text, data.style, elems.previewCtx)
      if vm.options.showGuide

        ctx.strokeStyle = '#514be3'
        # bezier curve
        ctx.beginPath()
        ctx.moveTo pts[0].x, pts[0].y
        ctx.bezierCurveTo pts[1].x, pts[1].y, pts[2].x, pts[2].y, pts[3].x, pts[3].y
        ctx.strokeStyle = '#000'
        ctx.stroke()
        ctx.closePath()
        # bezier curve
        ctx.beginPath()
        ctx.moveTo pts[0].x, pts[0].y
        ctx.lineTo pts[1].x, pts[1].y
        ctx.moveTo pts[2].x, pts[2].y
        ctx.lineTo pts[3].x, pts[3].y
        # ctx.strokeStyle = '#ccc'
        ctx.stroke()
        ctx.closePath()
      

    drag =
      start:
        x: 0, y: 0
      point:
        x: 0, y: 0

    getPoint = (curve, distance, width = 10) ->
      point = jsBezier.pointAlongCurveFrom(curve, 0, distance)
      ptL = jsBezier.pointAlongCurveFrom(curve, 0, distance - width * .5)
      ptr = jsBezier.pointAlongCurveFrom(curve, 0, distance + width * .5)
      if point and ptL and ptr
        point.radian = Math.atan((ptr.y - ptL.y) / (ptr.x - ptL.x))
      point

    getTextData = (text, style, ctx) ->
      ctx.font = "#{style.fontStyle} #{style.fontWeight} #{style.fontSize} #{style.fontFamily}"
      
      letters = text.split(/([\s\S])/).reduce (arr, char) ->
        if char isnt ''
          arr.push char
        arr
      , []
      textLen = vm.options.letterSpacing * -1
      letters = letters.reduce (arr, letter) ->
        each = letter: letter, width: ctx.measureText(letter).width
        textLen += (each.width + vm.options.letterSpacing)
        arr.push each
        arr
      , []
      letters: letters
      length: textLen


    render = (text, style, ctx) ->

      unless text
        text = vm.text

      curve = []
      if vm.points[0].x > vm.points[vm.points.length - 1].x
        curve = vm.points
      else
        for point in vm.points
          curve.unshift point
      data.totalLen = jsBezier.getLength curve
      data.style = getStyle($element.get(0)) 
      data.style.fontSize = '10px'





      data.text = getTextData(text, data.style, elems.previewCtx)
      spacingLen = (data.text.letters.length - 1) * vm.options.letterSpacing
      data.style.fontSize = parseInt(parseInt(data.style.fontSize, 10) * ((data.totalLen - spacingLen) / (data.text.length - spacingLen)), 10) 

      if data.style.fontSize > vm.options.maxFontSize
        data.style.fontSize = vm.options.maxFontSize

      data.style.fontSize = data.style.fontSize + 'px'
      data.text = getTextData(text, data.style, elems.previewCtx)
      # console.log data
      # console.log (data.totalLen / data.text.length)
      # console.log data.style.fontSize
      distance = 0.1
      distance = (data.totalLen - data.text.length) / 2
      
      gap = parseInt(data.style.fontSize, 10) / 10
      data.text.letters.reduce (prev, curr) ->
        # # console.log curr
        distance += (prev.width + curr.width) / 2 + vm.options.letterSpacing
        # # console.log curve, distance, curr.width
        point = getPoint(curve, distance, curr.width)
        
        if point
          # console.log curr.letter, point
          ctx.textAlign = 'center'
          ctx.textBaseline = vm.options.textBaseline

          
          
          if vm.options.color 
            color = vm.options.color 
          else
            color = style.color
          ctx.translate point.x, point.y
          ctx.rotate point.radian 
          # ctx.fillStyle = color
          # ctx.fillText curr.letter, gap * 2, gap * 2
          # ctx.shadowColor = '#000'
          # ctx.shadowOffsetX = 0;
          # ctx.shadowOffsetY = 0;
          # ctx.shadowBlur = 5;
          ctx.shadowColor = 'transparent'
          ctx.shadowBlur = 0
          ctx.fillStyle = '#FF9900'
          ctx.lineWidth = gap  * 2
          ctx.strokeStyle = '#7A1300'
          ctx.strokeText curr.letter, 0, gap
          ctx.strokeText curr.letter, 0, 0
          ctx.fillText curr.letter, 0, gap
          ctx.fillStyle = color

          ctx.shadowColor = '#000'
          ctx.shadowOffsetX = 0
          ctx.shadowOffsetY = 0
          ctx.shadowBlur = gap        
          
          # ctx.lineWidth = 1
          # ctx.shadowColor = 'transparent'
          # ctx.shadowBlur = 0
          ctx.fillText curr.letter, 0, 0
          # ctx.strokeText curr.letter, 0, 0
          if vm.options.showGuide
            ctx.beginPath()
            ctx.arc 0, 0, 2, 0, 2 * Math.PI
            ctx.fillStyle = 'red'
            ctx.fill()
            ctx.closePath()
          ctx.rotate point.radian * -1
          ctx.translate point.x * -1, point.y * -1
        curr
      , { letter: '', width: 0 }

      ctx.lineWidth = 1
      ctx.shadowColor = 'transparent'
      ctx.shadowBlur = 0


    getStyle = (element) ->
      inherits = ['fontStyle', 'fontWeight', 'fontSize', 'fontFamily', 'color', 'textAlign']
      style =
        fontStyle: 'normal'
        fontWeight: ''
        fontSize: '14px'
        fontFamily: ''
        color: '#000000'
        textAlign: 'left'
      computedStyle = window.getComputedStyle element
      for key of computedStyle
        if inherits.indexOf(key) isnt -1
          style[key] = computedStyle[key]
      style

    data = {}

    $scope.$watch 'vm.text', (text) ->
      if text
        # data.letters = text.split(/([\s\S])/).reduce (arr, char) ->
        #   if char isnt ''
        #     arr.push char
        #   arr
        # , []
        # data.ge
        

        # # console.log getStyle($element.get(0))
        renderPreview()
        # render(text, data.style, elems.previewCtx)
      return

    $scope.$watch 'vm.options', ->
      renderPreview()
    , true
    $scope.$watch 'vm.points', ->
      if vm.options and vm.options.snapToGrid and vm.points
        for point in vm.points
          point.x = Math.round(point.x / vm.options.unit) * vm.options.unit
          point.y = Math.round(point.y / vm.options.unit) * vm.options.unit
        

      renderPreview()
      return
    , true
    vm.dragHandle = (point, event) ->
      drag.start.x = event.pageX
      drag.start.y = event.pageY
      drag.point.x = point.x
      drag.point.y = point.y
      doc.off '.drag-handle'
      doc.on 'mousemove.drag-handle', (event) ->
        $timeout ->
          point.x = drag.point.x - (drag.start.x - event.pageX)
          point.y = drag.point.y - (drag.start.y - event.pageY)
          

      doc.on 'mouseup.drag-handle', (event) ->
        doc.off '.drag-handle'
      return

    return
  