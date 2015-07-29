'use strict'

angular.module 'rangers'
.directive 'box3d', ->
  restrict: 'EA'
  templateUrl: 'app/directives/box-3d.directive.html'
  transclude: true
  scope:
    width: '@width'
    height: '@height'
    depth: '@depth'
    perspective: '@perspective'
    border: '@border'
    transition: '@transition'
    rotate: '@rotate'
    scale: '@scale'
    rotateHover: '@rotateHover'
    scaleHover: '@scaleHover'
  bindToController: true
  controllerAs: 'vm'
  controller: ($scope, $element, $timeout) ->
    vm = @

    classId = 'box-' + parseInt(Math.random() * 100000, 10)
    
    style = document.createElement('style')
    $element.append(style)
    $element.addClass(classId)

    setStyle = ->
      vm.width = 300 unless vm.width
      vm.height = 300 unless vm.height
      vm.depth = 300 unless vm.depth
      vm.perspective = 1000 unless vm.perspective

      styles = []
      styles.push ['.box-container', "width:#{vm.width}px;height:#{vm.height}px;perspective:#{vm.perspective}px"]    
      styles.push ['.front, .back', "width:#{vm.width}px;height:#{vm.height}px;"]
      styles.push ['.left, .right', "width:#{vm.height}px;height:#{vm.depth}px;top:#{(vm.height - vm.depth) * .5}px;left:#{(vm.width - vm.height) * .5}px"]
      styles.push ['.top, .bottom', "width:#{vm.width}px;height:#{vm.depth}px;top:#{(vm.height - vm.depth) * .5}px;"]
      styles.push ['.front', "transform: rotateY(0deg) translateZ(#{vm.depth * .5}px);"]
      styles.push ['.back', "transform: rotateX(180deg) translateZ(#{vm.depth * .5}px);"]
      styles.push ['.right', "transform: rotateY(90deg) rotateZ(-90deg) translateZ(#{vm.width * .5}px);"]
      styles.push ['.left', "transform: rotateY(-90deg) rotateZ(90deg) translateZ(#{vm.width * .5}px);"]
      styles.push ['.top', "transform: rotateX(90deg) rotateZ(180deg) translateZ(#{vm.height * .5}px);"]
      styles.push ['.bottom', "transform: rotateX(-90deg) translateZ(#{vm.height * .5}px);"]
      
      styles.push ['.box-container', "width:#{vm.width}px;height:#{vm.height}px;-webkit-perspective:#{vm.perspective}px"]    
      styles.push ['.front, .back', "width:#{vm.width}px;height:#{vm.height}px;"]
      styles.push ['.left, .right', "width:#{vm.height}px;height:#{vm.depth}px;top:#{(vm.height - vm.depth) * .5}px;left:#{(vm.width - vm.height) * .5}px"]
      styles.push ['.top, .bottom', "width:#{vm.width}px;height:#{vm.depth}px;top:#{(vm.height - vm.depth) * .5}px;"]
      styles.push ['.front', "-webkit-transform: rotateY(0deg) translateZ(#{vm.depth * .5}px);"]
      styles.push ['.back', "-webkit-transform: rotateX(180deg) translateZ(#{vm.depth * .5}px);"]
      styles.push ['.right', "-webkit-transform: rotateY(90deg) rotateZ(-90deg) translateZ(#{vm.width * .5}px);"]
      styles.push ['.left', "-webkit-transform: rotateY(-90deg) rotateZ(90deg) translateZ(#{vm.width * .5}px);"]
      styles.push ['.top', "-webkit-transform: rotateX(90deg) rotateZ(180deg) translateZ(#{vm.height * .5}px);"]
      styles.push ['.bottom', "-webkit-transform: rotateX(-90deg) translateZ(#{vm.height * .5}px);"]
      


      if vm.border
        styles.push ['.front, .back, .left, .right, .top, .bottom', "border:#{vm.border};"]
      if vm.transition
        styles.push ['.box.animate', "transition:#{vm.transition};"]
      if vm.rotate or vm.scale
        rotate = [0, 0, 0]
        scale = 1
        if vm.rotate
          tmp = vm.rotate.replace(/[^0-9,\-]/g, '').split(',')
          if tmp.length is 3
            rotate = tmp
        if vm.scale
          scale = vm.scale.replace(/[^0-9\.]/g, '')
        styles.push ['.box', "transform:translateZ(#{vm.depth * -.5}px) rotateX(#{rotate[0]}deg) rotateY(#{rotate[1]}deg) rotateZ(#{rotate[2]}deg) scale3d(#{scale}, #{scale}, #{scale});"]
        styles.push ['.box', "-webkit-transform:translateZ(#{vm.depth * -.5}px) rotateX(#{rotate[0]}deg) rotateY(#{rotate[1]}deg) rotateZ(#{rotate[2]}deg) scale3d(#{scale}, #{scale}, #{scale});"]
      if vm.rotateHover or vm.scaleHover
        rotate = [0, 0, 0]
        scale = 1
        if vm.rotateHover
          tmp = vm.rotateHover.replace(/[^0-9,]/g, '').split(',')
          if tmp.length is 3
            rotate = tmp
        if vm.scaleHover
          scale = vm.scaleHover.replace(/[^0-9\.]/g, '')
        styles.push ['.box:hover', "transform:translateZ(#{vm.depth * -.5}px) rotateX(#{rotate[0]}deg) rotateY(#{rotate[1]}deg) rotateZ(#{rotate[2]}deg) scale3d(#{scale}, #{scale}, #{scale});"]
        styles.push ['.box:hover', "-webkit-transform:translateZ(#{vm.depth * -.5}px) rotateX(#{rotate[0]}deg) rotateY(#{rotate[1]}deg) rotateZ(#{rotate[2]}deg) scale3d(#{scale}, #{scale}, #{scale});"]

      css = ''
      for each in styles
        if each.length > 1
          css += ".#{classId} " + each[0].replace(/,/g, ", .#{classId} ")
          css += "{#{each[1]}}"

      style.innerHTML = css
      return

    $scope.$watchGroup ['vm.width', 'vm.height', 'vm.depth'], ->
      setStyle()
      return

    $timeout ->
      vm.animate = true
      return

    return