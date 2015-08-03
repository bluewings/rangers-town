'use strict'


frameSizes =
  sm: { width: 740, height: 705, padding: 40 }
  md: { width: 840, height: 705, padding: 40 }
  lg: { width: 940, height: 705, padding: 40 }
  xl: { width: 1040, height: 705, padding: 40 }
  xxl: { width: 1140, height: 705, padding: 40 }

playerSizes =
  sm: { width: 84 }
  md: { width: 122 }
  lg: { width: 150 }
  xl: { width: 200 }

playerLayout =
  7: [1, 2, 3, -3, -2, -1]
  6: [1, 2, 3, -2, -1]
  5: [1, 2, -2, -1]
  4: [1, 2, -1]
  3: [1, -1]
  2: [1]


angular.module 'rangers'
.directive 'frame', ->
  restrict: 'C'
  controller: ($scope, $element, $compile) ->
    inputMessage = $compile('<div class="player-message"><input-message></input-message></div>')($scope)
    $element.find('.player-me').append(inputMessage)
    return

.service 'frameUtil', ->

  defaultOptions =
    frameSize: 'lg'
    playerSize: 'md'
  


  getPosition: (numOfPlayer, playerIndex, userOptions = {}) ->
    options = {}
    angular.extend options, defaultOptions, userOptions
    frame = frameSizes[options.frameSize]
    player = playerSizes[options.playerSize]

    indexes = playerLayout[numOfPlayer];
    index = indexes.indexOf playerIndex

    playerWidth = player.width * 1.7

    margin = (frame.width - frame.padding * 2 - playerWidth * (numOfPlayer - 1)) / (numOfPlayer - 2);
    gap = playerWidth + margin

    if numOfPlayer > 2
      top = frame.padding
      if numOfPlayer > 3 and (index is 0 or index is (numOfPlayer - 2))
        top = frame.padding * 3
      left = frame.padding + playerWidth * .5 + gap * (index)


    # console.log frame, player, left, top

    left: left
    top: top
    marginLeft: playerWidth * -.5





