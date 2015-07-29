'use strict'

angular.module 'rangers'
.directive 'trianglify', ->
  restrict: 'A'
  scope:
    colors: '@colors'
  bindToController: true
  controllerAs: 'vm'
  controller: ($scope) ->
    vm = @
    return

  link: (scope, element, attrs) ->
    
    classId = 'trianglify-' + parseInt(Math.random() * 100000, 10)
    style = document.createElement('style')
    element.append(style)
    element.addClass(classId)
    colors = Object.keys(colorbrewer)
    #   'Spectral'
    #   # 'Blues'
    #   # 'Greens'
    #   # 'Purples'
    #   'YlGnBu'
    #   'YlOrRd'
    #   'GnBu'
    #   'YlOrBr'
    #   'Purples'
    #   'Blues'
    #   'Oranges'
    #   'Grays'
    #   'Reds'
    #   'PuRd'
    # ]
    if scope.vm.colors
      x_colors = scope.vm.colors
    else 
      x_colors = colors[parseInt(Math.random() * colors.length, 10)]
    
    console.log x_colors
    pattern = Trianglify({
      # width: window.innerWidth, 
      # height: window.innerHeight
      width: element.outerWidth()
      height: element.outerHeight()
      # cell_size: 80
      
      x_colors: x_colors
    })
    styles = []
    styles.push ".#{classId} {"  
    styles.push "background:url(#{pattern.canvas().toDataURL()});"
    styles.push 'background-size:cover;'
    styles.push 'background-position:50% 0;'
    styles.push "}"
    style.innerHTML = styles.join('')
    return