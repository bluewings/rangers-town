'use strict'

angular.module 'rangers'
.controller 'Sample2DirectiveController', ($scope, $element, $timeout, $http, user, resource) ->  
  
  vm = @

  vm.modes = ['css sprite animateion', 'image merge']

  vm.mode = vm.modes[0]
  vm.classname = 'sample'
  vm.duration = '500'

  vm.selectMode = (mode) ->
    vm.mode = mode
    return

  $scope.$watchGroup ['vm.mode', 'vm.classname', 'vm.duration'], ->
    drawSelected()



  units = [
    # 'unit01-shield'
    # 'unit02-electric'
    # 'unit03-poison'
    # 'unit04-shouting'
    # 'unit05-slow'
    # # 'unit06-ice'
    'unit07-heal'
    # 'unit08-anger'
    # 'unit09-awaken'
    # 'unit10-spark'
    # 'unit11-light'
    # 'unit12-magic'
    # 'unit13-thunder'
    # 'unit14-ice2'
    'unit15-iceblow'
    'unit16-powerup'
    # 'unit16-powerup'
  ]
  id = units[Math.floor(Math.random() * units.length)]
  uriImg = "/assets/badges/#{id}/#{id}.png"
  uriPlist = "/assets/badges/#{id}/#{id}.plist"
  img = document.createElement 'IMG'

  img.onload = ->
    # console.log img
    process img


  img.src = uriImg

  dict = {}
  selected = {}

  canvas = $element.find('canvas').get(0)
  ctx = canvas.getContext '2d'



  canvas2 = $element.find('canvas').get(1)
  ctx2 = canvas2.getContext '2d'

  drawSelected = ->
    maxX = 0
    maxY = 0
    i = 0
    for key, each of selected
      if maxX < each[2]
        maxX = each[2]
      if maxY < each[3]
        maxY = each[3]
      i++

    
    ctx2.clearRect 0, 0, canvas2.width, canvas2.height
    $(canvas2).css 'border', '2px solid black'
    i = cuts.length
    if vm.mode is vm.modes[0]
      $(canvas2).attr
        width: maxX * i
        height: maxY
    else
      $(canvas2).attr
        width: maxX
        height: maxY
    ctx2.clearRect 0, 0, canvas2.width, canvas2.height
    # i = 0
    
    # for key, each of selected
    #   ctx2.drawImage img, each[0], each[1], each[2], each[3],
    #     i * maxX + parseInt((maxX - each[2]) / 2, 10),
    #     0 + parseInt((maxY - each[3]) / 2, 10),
    #     each[2], each[3]
    #   if vm.mode is vm.modes[0]
    #     i++

    i = cuts.length
    for each, i in cuts
      ctx2.drawImage img, each[0], each[1], each[2], each[3],
        i * maxX + parseInt((maxX - each[2]) / 2, 10),
        0 + parseInt((maxY - each[3]) / 2, 10),
        each[2], each[3]
      if vm.mode is vm.modes[0]
        i++      

    vm.styles = []
    vm.styles.push "width:#{maxX}px"
    vm.styles.push "height:#{maxY}px"
    vm.styles.push "background:url(#{canvas2.toDataURL()})"

    # @keyframes play {
    #    100% { background-position: -1900px; }
    # }

    $timeout ->
      vm.style  = "@keyframes #{vm.classname}-play {"
      vm.style += "100% { background-position: #{maxX * i * -1}px; }"
      vm.style += '}'
      vm.style += ".#{vm.classname} {"
      vm.style += vm.styles.join(';') + ';'
      vm.style += "animation: #{vm.classname}-play #{vm.duration}ms steps(#{i}) infinite;"
      vm.style += '}'
  # vm.style = '.sample-css { width: 100px; height: 100px; border: 3px solid red; }'
  renderSource = ->

    ctx.drawImage img, 0, 0

    # textureRect: "{{124, 116}, {21, 21}}"
    for name, value of dict
      textureRect = value.textureRect.replace(/[{}]/g, '').split(',')
      rect = []
      textureRect.reduce (prev, curr) ->
        rect.push parseInt(curr, 10)
      , null
      value.rect = rect
      # console.log rect
      ctx.strokeStyle = '#ddd'
      ctx.strokeRect rect[0], rect[1], rect[2], rect[3]

    ctx.font = "20px Georgia"
    ctx.fillText id, 10, 50
    return

  cuts = []
  process = (img) ->
    # canvas = document.createElement 'CANVAS'
    

    # console.log canvas
    # console.log img

    canvas.width = img.width
    canvas.height = img.height
    # $element.find('.container').prepend canvas

    $(canvas).on 'click', (event) ->
      # # console.log event
      $timeout ->
        vm.evt =
          x: event.offsetX
          y: event.offsetY

        for name, each of dict


          
          if each.rect[0] < vm.evt.x and vm.evt.x < each.rect[0] + each.rect[2] and each.rect[1] < vm.evt.y and vm.evt.y < each.rect[1] + each.rect[3]
            # console.log each.rect  

            key = each.rect.join(',')
            if selected[key]
              delete selected[key]

            else
              selected[key] = each.rect
            cuts.push each.rect
            drawSelected()






    $http.get uriPlist
    .success (data) ->
      # console.log data
      xml = $(data)

      dict = {}
      spriteName = null
      lastName = null
      xml.find('key, string').each (index, item) ->
        if item.tagName is 'KEY'
          if item.innerText.search(/\.png$/) isnt -1
            spriteName = item.innerText
            dict[spriteName] = {}
          else if item.innerText is 'metadata'
            spriteName = null
          else if item.innerText isnt 'aliases' and spriteName and dict[spriteName]
            lastName = item.innerText

        if item.tagName is 'STRING' and spriteName and dict[spriteName] and lastName
          dict[spriteName][lastName] = item.innerText
          lastName = null


      renderSource()

      $(document.body).css 'background-color', 'silver'


      # props = {}
      # if $(item).find('key').eq(0).text() is 'aliases'
      #   # console.log item
      #   tagName = null


      #   $(item).find('key, string').each (subIndex, subItem) ->
      #     if subItem.tagName is 'KEY'
      #       tagName = subItem.innerText
      #     else if subItem.tagName is 'STRING'
      #       props[tagName] = 

      #       # console.log tagName, subItem.innerText
      # # # console.log item




  vm

.controller 'SampleDirectiveController', ($scope, $timeout, user, resource) ->  
  vm = @

  vm.ranger =
    client: user
    message: ''
    size: ''
    valign: ''
    flip: ''
    badge: 'shield'
    animation: ''
    animationInfinite: ''
    options:
      sizes: ['xs', 'sm', 'md', 'lg', 'xl']
      valigns: ['top', 'middle', 'bottom']
      flips: ['flip', 'none']
      badges: ['shield', 'anger', 'ice', 'sword', 'light', 'poison', 'electric', 'thunder', 'heart']
      animations: ['bounce', 'flash', 'pulse', 'rubberBand', 'shake', 'swing', 'tada', 'wobble', 'jello', 'bounceIn', 'bounceInDown', 'bounceInLeft', 'bounceInRight', 'bounceInUp', 'bounceOut', 'bounceOutDown', 'bounceOutLeft', 'bounceOutRight', 'bounceOutUp', 'fadeIn', 'fadeInDown', 'fadeInDownBig', 'fadeInLeft', 'fadeInLeftBig', 'fadeInRight', 'fadeInRightBig', 'fadeInUp', 'fadeInUpBig', 'fadeOut', 'fadeOutDown', 'fadeOutDownBig', 'fadeOutLeft', 'fadeOutLeftBig', 'fadeOutRight', 'fadeOutRightBig', 'fadeOutUp', 'fadeOutUpBig', 'flipInX', 'flipInY', 'flipOutX', 'flipOutY', 'lightSpeedIn', 'lightSpeedOut', 'rotateIn', 'rotateInDownLeft', 'rotateInDownRight', 'rotateInUpLeft', 'rotateInUpRight', 'rotateOut', 'rotateOutDownLeft', 'rotateOutDownRight', 'rotateOutUpLeft', 'rotateOutUpRight', 'hinge', 'rollIn', 'rollOut', 'zoomIn', 'zoomInDown', 'zoomInLeft', 'zoomInRight', 'zoomInUp', 'zoomOut', 'zoomOutDown', 'zoomOutLeft', 'zoomOutRight', 'zoomOutUp', 'slideInDown', 'slideInLeft', 'slideInRight', 'slideInUp', 'slideOutDown', 'slideOutLeft', 'slideOutRight', 'slideOutUp']
    set: (name, value) ->
      if vm.ranger[name] is value
        vm.ranger[name] = ''
      else
        vm.ranger[name] = value
      return
    random: ->
      resource.rangers.then (rangers) ->
        vm.ranger.client.character = rangers[Math.floor(Math.random() * rangers.length)].filename

  unless user
    resource.rangers.then (rangers) ->
      vm.ranger.client =
        character: rangers[Math.floor(Math.random() * rangers.length)].filename

  vm.card =
    open: 'open'
    # client: user
    # message: ''
    # size: ''
    # valign: ''
    # flip: ''
    # badge: ''
    # animation: ''
    # animationInfinite: ''
    options:
      frontColors: ['black', 'white']
      numbers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
      suits: ['S', 'H', 'C', 'D']
      ranks: ['2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A']
      sizes: ['xs', 'sm', 'md', 'lg', 'xl']
      covers: ['blue', 'green', 'orange', 'red', 'black', 'grey', 'white']
      valigns: ['top', 'middle', 'bottom']
      flips: ['flip', 'none']
      badges: ['shield', 'anger', 'ice', 'sword', 'light', 'poison', 'electric', 'thunder', 'heart']
      animations: ['bounce', 'flash', 'pulse', 'rubberBand', 'shake', 'swing', 'tada', 'wobble', 'jello', 'bounceIn', 'bounceInDown', 'bounceInLeft', 'bounceInRight', 'bounceInUp', 'bounceOut', 'bounceOutDown', 'bounceOutLeft', 'bounceOutRight', 'bounceOutUp', 'fadeIn', 'fadeInDown', 'fadeInDownBig', 'fadeInLeft', 'fadeInLeftBig', 'fadeInRight', 'fadeInRightBig', 'fadeInUp', 'fadeInUpBig', 'fadeOut', 'fadeOutDown', 'fadeOutDownBig', 'fadeOutLeft', 'fadeOutLeftBig', 'fadeOutRight', 'fadeOutRightBig', 'fadeOutUp', 'fadeOutUpBig', 'flipInX', 'flipInY', 'flipOutX', 'flipOutY', 'lightSpeedIn', 'lightSpeedOut', 'rotateIn', 'rotateInDownLeft', 'rotateInDownRight', 'rotateInUpLeft', 'rotateInUpRight', 'rotateOut', 'rotateOutDownLeft', 'rotateOutDownRight', 'rotateOutUpLeft', 'rotateOutUpRight', 'hinge', 'rollIn', 'rollOut', 'zoomIn', 'zoomInDown', 'zoomInLeft', 'zoomInRight', 'zoomInUp', 'zoomOut', 'zoomOutDown', 'zoomOutLeft', 'zoomOutRight', 'zoomOutUp', 'slideInDown', 'slideInLeft', 'slideInRight', 'slideInUp', 'slideOutDown', 'slideOutLeft', 'slideOutRight', 'slideOutUp']
    set: (name, value) ->
      if vm.card[name] is value
        vm.card[name] = ''
      else
        vm.card[name] = value
      return
    random: ->
      resource.cards.then (cards) ->
        vm.card.client.character = cards[Math.floor(Math.random() * cards.length)].filename

  
  $timeout ->
    greeting = '안녕하세요.'
    vm.ranger.message = greeting
    $timeout ->
      if vm.ranger.message is greeting
        vm.ranger.message = ''
    , 1500
  , 1000

  return