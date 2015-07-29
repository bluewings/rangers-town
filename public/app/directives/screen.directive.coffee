'use strict'

angular.module 'rangers'
.directive 'screen', ->
  restrict: 'A'
  controller: ($scope, $element, resource) ->
    vm = @

    return

  link: (scope, element, attrs) ->

    classId = 'screen-' + parseInt(Math.random() * 100000, 10)
    
    style = document.createElement('style')
    element.append(style)
    element.addClass(classId)

    setStyle = ->

      width = parseInt(attrs.width, 10)
      height = parseInt(attrs.height, 10)

      view = element.closest('[ui-view]')
      parent = element.parent()
      vRect = view[0].getBoundingClientRect()
      pRect = parent[0].getBoundingClientRect()
      rect = element[0].getBoundingClientRect()

      top = rect.top - vRect.top
      bottom = top + height
      console.log vRect
      console.log pRect
      console.log rect

      margin = 20
      tHeight = document.documentElement.clientHeight - top - margin

      console.log top, bottom, document.documentElement.clientHeight
      console.log tHeight, (tHeight / height)




      scale = (tHeight / height)

      styles = []
      styles.push ".#{classId} {"
      styles.push "width:#{width}px;"
      styles.push "height:#{height}px;"
      # styles.push "height:#{height}px;"
      styles.push "transform:scale(#{scale});"
      styles.push '}'
      
      console.log '>>> attrs'
      style.innerHTML = styles.join ''
      return

    setStyle()
    console.log attrs.width, attrs.height
    return