'use strict'

angular.module 'rangers'
.animation '.hero-move', ->
  _leavedList = []
  _enteredList = []

  now = ->
    Math.floor(new Date().getTime() / 10)

  _now = now()

  console.log _now

  enter = (element, done) ->
    _enteredList.push
      element: element
      done: done
    element.css 'visibility', 'hidden'
    setTimeout start
    return

  leave = (element, done) ->
    _leavedList.push 
      element: element
      done: done
    setTimeout start
    return
 
  start = ->
    # 연결된 항목을 찾는다.
    pairs = {}
    while _leavedList.length > 0
      leaved = _leavedList.shift()
      leavedHeroId = leaved.element[0].getAttribute('hero-id')
      unless pairs[leavedHeroId]
        pairs[leavedHeroId] =
          from: leaved
          to: null
          moving: null

    while _enteredList.length > 0
      entered = _enteredList.shift()
      enteredHeroId = entered.element[0].getAttribute('hero-id')
      if pairs[enteredHeroId] and pairs[enteredHeroId].to is null
        easing = entered.element[0].getAttribute('easing')
        duration = entered.element[0].getAttribute('duration')
        pairs[enteredHeroId].to = entered
        pairs[enteredHeroId].easing = if easing then easing else 'ease-in-out'
        pairs[enteredHeroId].duration = if duration then duration else '1s'
      else
        # enter 항목 중 맞는 짝이 없다면 바로 표시
        entered.element.css 'visibility', ''
        entered.done()

    zIndex = now() - _now

    zIndex = 0

    # console.log zIndex
     
    for key, pair of pairs
      if pair.to is null
        # leave 항목 중 맞는 짝이 없다면 바로 표시
        pair.from.done()
      else
        pair.base = $('<div class="pair-base"></div>')
        pair.cloned = pair.from.element.clone()
        pair.moving = $('<div class="pair-moving"></div>').append pair.cloned
        
        bases = pair.to.element.parent().find('> .pair-base')
        # if bases.size() > 0
        #   bases.last().after pair.base
        # else
        #   bases.end().prepend pair.base
        pair.to.element.parent().prepend pair.base
        
        # 좌표 계산 및 이전의 스타일 확인
        baseRect = pair.base[0].getBoundingClientRect()
        transform = pair.from.element.css 'transform'
        fromRect = pair.from.element[0].getBoundingClientRect()
        fromStyle = window.getComputedStyle pair.from.element[0]
        transform = "translate3d(#{(fromRect.left - baseRect.left)}px, #{(fromRect.top - baseRect.top)}px, 0)";
        
        # dom element 적용
        pair.moving.css
          '-webkit-transition': "all #{pair.duration} #{pair.easing}"
          transition: "all #{pair.duration} #{pair.easing}"
          '-webkit-transform': transform
          transform: transform
          zIndex: zIndex++

        pair.cloned.css
          '-webkit-transition': "all #{pair.duration} #{pair.easing}"
          transition: "all #{pair.duration} #{pair.easing}"

        pair.from.element.css 'visibility', 'hidden'
        pair.from.element.css
          transition: "all #{pair.duration} ease-in-out"
          width: fromStyle.width
          height: fromStyle.height
          padding: fromStyle.padding
          marging: fromStyle.margin

        pair.base.append pair.moving

        # console.log key

        tmpTransition = pair.to.element.css 'transition'
        pair.moving.css
          transition: "all #{pair.duration} ease-in-out"
        # activate
        ((pair, baseRect) ->          
          setTimeout ->
            # 좌표계산
            tmpTransform = pair.to.element.css 'transform'
            
            pair.to.element.css 'transform', 'none'
            toRect = pair.to.element[0].getBoundingClientRect()
            # console.log toRect.width, toRect.height
            pair.to.element.css
              # transition: "all #{pair.duration} ease-in-out"
              transform: tmpTransform

            transform = "translate3d(#{(toRect.left - baseRect.left)}px, #{(toRect.top - baseRect.top)}px, 0)";
            
            # 이동처리
            pair.moving.css
              '-webkit-transform': transform
              transform: transform

            pair.cloned.attr('class', pair.to.element.attr('class'))

            pair.from.element.css
              width: 0
              height: 0
              padding: 0
              margin: 0

            # 이동완료처리
            pair.moving.on 'transitionend', (event) ->
              return if event.target isnt pair.moving[0]

              # return
              pair.to.element.css
                visibility: ''
                transition: tmpTransition

              setTimeout ->  
                pair.base.remove()
              , 100
              pair.from.done()
              pair.to.done()
          , 100

        )(pair, baseRect)

    return

  enter: (element, done) ->
    enter element, done
    return

  leave: (element, done) ->
    leave element, done
    return
