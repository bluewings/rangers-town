do ->

  alAngularHero = ($animateCss) ->
    _fromScreen = undefined
    _toScreen = undefined
    _doneList = undefined
    _startTimer = undefined
    _movingList = undefined
    # Capture the screen that is transitioning in

    enter = (screen, done) ->
      _toScreen = screen
      _doneList.push done
      tryStart()

    # Capture the screen that is transitioning out

    leave = (screen, done) ->
      _fromScreen = screen
      _doneList.push done
      screen.addClass 'hero-leave'
      tryStart()

    # If we have both screens then trigger the transition

    tryStart = ->
      if !_fromScreen or !_toScreen
        # Allow time to get a second screen, or else cancel
        _startTimer = setTimeout(->
          finish true
          return
        )
        null
      else
        if _startTimer
          clearTimeout _startTimer
        # Both screens, so start now
        setTimeout start
        # Return a cancel function, which should only call clear once
        cancelled = false
        ->
          if !cancelled
            cancelled = true
            clear()
          return

    # Start the hero transitions

    start = ->
      # Get hero elements from both screens
      fromHeros = _fromScreen[0].getElementsByClassName('hero')
      toHeros = _toScreen[0].getElementsByClassName('hero')
      # Find all the matching pairs
      pairs = []
      n = 0
      while n < fromHeros.length
                m = 0
        while m < toHeros.length
          if fromHeros[n].getAttribute('hero-id') == toHeros[m].getAttribute('hero-id')
            pairs.push
              from: fromHeros[n]
              to: toHeros[m]
          m++
        n++
      # Trigger the animation for each pair
      pairs.forEach (pair) ->
        animateHero angular.element(pair.from), angular.element(pair.to)
        return
      finish()
      return

    # Animate a hero element from one position to another

    animateHero = (fromHero, toHero) ->
      # Get the screen positions
      fromRect = getScreenRect(fromHero, _fromScreen)
      # Clone and hide the source and target elements
      moving = fromHero.clone()
      fromHero.css 'visibility', 'hidden'
      toHero.css 'visibility', 'hidden'
      # Move outside the screen element and apply animation css
      _fromScreen.parent().append moving
      moving.css(
        top: fromRect.top + 'px'
        left: fromRect.left + 'px'
        width: fromRect.width + 'px'
        height: fromRect.height + 'px'
        margin: '0').addClass 'hero-animating'
      # Setup the event handler for the end of the transition
      handler = 
        complete: false
        onComplete: ->
          # Allows us to track which animations have finished
          handler.complete = true
          finish()
          return
        remove: ->
          # Show the original target element
          toHero.css 'visibility', ''
          # Unbind the event handler and remove the element
          moving.unbind 'transitionend', handler.onComplete
          moving.remove()
          return
      _movingList.push handler
      # Delay here allows the DOM to update before starting
      setTimeout (->
        toRect = getScreenRect(toHero, _toScreen)
        # Move to the new position (animated by css transition)
        transform = 'translate3d(' + toRect.left - (fromRect.left) + 'px, ' + toRect.top - (fromRect.top) + 'px, 0)'
        moving.css(
          '-webkit-transform': transform
          transform: transform
          width: toRect.width + 'px'
          height: toRect.height + 'px').addClass 'hero-animating-active'
        # Switch the animating element to the target's classes,
        # which allows us to animate other properties like color,
        # border, corners, etc.
        moving.attr 'class', toHero.attr('class') + ' hero-animating'
        # Handle the event at the end of transition
        moving.bind 'transitionend', handler.onComplete
        return
      ), 50
      return

    # Get the current screen position and size of an element

    getScreenRect = (element, screen) ->
      elementRect = element[0].getBoundingClientRect()
      screenRect = screen[0].getBoundingClientRect()
      {
        top: elementRect.top - (screenRect.top)
        left: elementRect.left - (screenRect.left)
        width: elementRect.width
        height: elementRect.height
      }

    # Finish up if all elements have finished animating

    finish = (cancelled) ->
      # Check that all the moving elements are complete
      allComplete = true
      if !cancelled
        _movingList.forEach (m) ->
          allComplete = allComplete and m.complete
          return
      if allComplete
        # Call "done" on both screens (which may call "clear" so clone the array)
        doneCallbacks = _doneList.slice(0)
        doneCallbacks.forEach (done) ->
          done()
          return
        # Make sure we've cleared for the next time
        clear()
      return

    # Clear everything down and initialise for next time

    clear = ->
      _fromScreen = null
      _toScreen = null
      _doneList = []
      # Call remove for each animating hero element
      if _movingList
        _movingList.forEach (m) ->
          m.remove()
          return
      _movingList = []
      return

    clear()
    # Definition of the AngularJS animation
    {
      enter: (element, done) ->
        if $animateCss
          runner = $animateCss(element,
            event: 'enter'
            structural: true).start()
          enter element, ->
            runner.done done
            return
        else
          enter element, done
      leave: (element, done) ->
        if $animateCss
          runner = $animateCss(element,
            event: 'leave'
            structural: true).start()
          leave element, ->
            runner.done done
            return
        else
          leave element, done

    }

  'use strict'
  alAngularHero.$inject = []
  over14 = angular.version.major >= 1 and angular.version.minor >= 4
  if over14
    alAngularHero.$inject.push '$animateCss'
  angular.module('alAngularHero', [ 'ngAnimate' ]).animation '.hero-transition', alAngularHero
  return

# ---
# generated by js2coffee 2.1.0