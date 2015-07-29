'use strict'

angular.module 'rangers'
.directive 'ranger', ($timeout) ->
  restrict: 'E'
  replace: true
  templateUrl: 'app/directives/ranger.directive.html'
  scope:
    client: '=client'
    message: '@message'
    size: '@size'
    valign: '@valign'
    flip: '@flip'
    badge: '@badge'
    disabled: '@disabled'
  bindToController: true
  controllerAs: 'vm'
  controller: ($scope, $element, mySocket, Friend) ->
    vm = @

    vm.profile = null

    vm.character = null

    vm.socketStat = mySocket.stat

    vm.cachedFriend = Friend.cache

    # Friend.query (lists) ->

    #   console.log lists
    #   console.log arguments

    #   if list[0]
    #     list[0].$delete()

    vm.toggleFavorite = ->
      if vm.profile and vm.profile._id
        if vm.cachedFriend and vm.cachedFriend.linkDict[vm.profile._id]
          # 삭제
          console.log vm.cachedFriend.linkDict[vm.profile._id]
          vm.cachedFriend.linkDict[vm.profile._id].$delete ->
            # console.log 'delete success'
            Friend.updateFriends()

        else
          # 추가
          friend = new Friend()
          friend.uid2 = vm.profile._id
          friend.$save (link) ->
            # console.log '>>> success'
            # console.log link
            Friend.updateFriends()
        
      return

    vm.checkSize = ->
      img = $element.find('.img-wrap img')[0]

      measure = ->
        $timeout ->
          rect = img.getBoundingClientRect()
          if vm.imgWidth isnt rect.width or vm.imgHeight isnt rect.height  
            $timeout ->
              vm.imgWidth = rect.width
              vm.imgHeight = rect.height 
              return
          return

      if img.complete
        measure()
      else
        img.onload = measure

      return

    $scope.$watch 'vm.client', (client) ->
      
      if client and client.profile
        vm.profile = client.profile
      else if client and client.client and client.client.profile
        vm.profile = client.client.profile
      else if client
        vm.profile = client
      return

    $scope.$watch 'vm.size', (size) ->
      $timeout ->
        vm.checkSize()
        return
      , 10
      $timeout ->
        vm.checkSize()
        return
      , 50
      $timeout ->
        vm.checkSize()
        return
      , 100
      return

    $scope.$watch 'vm.badge', (badge) ->
      if typeof badge isnt 'string'
        badge = ''
      tmp = badge.split(':')
      vm._badge = tmp[0]
      vm._badgeAnimation = ''
      if tmp.length > 1
        vm._badgeAnimation = tmp[1]
      return

    $element.find('.img-wrap').on 'transitionend webkitTransitionEnd', (event) ->
      vm.checkSize()
      return

    return

  link: (scope, element, attrs) ->

    scope.vm.checkSize()
    return