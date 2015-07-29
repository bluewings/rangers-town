'use strict'

angular.module 'rangers'
.directive 'gamePackage', ->
  restrict: 'E'
  replace: false
  templateUrl: 'app/directives/game-package.directive.html'
  scope:
    user: '=user'
  bindToController: true
  controllerAs: 'vm'
  controller: ($scope, $rootScope, $timeout, Auth, resource) ->
    vm = @

    vm.auth =
      logout: ->
        Auth.logout()
        vm.user = null

    vm.colorbrewer = colorbrewer.YlGn['9']

    # 로그인 상태가 변경되면 user 정보를 갱신해야한다.
    $rootScope.$on 'loginStateChange', ->
      Auth.getCurrentUserAsync()
      .then (user) ->
        vm.user = user
        return
      return

    # 참고: https://daneden.github.io/animate.css/
    animations = ['bounce', 'rubberBand', 'swing', 'tada', 'wobble', 'jello', 'bounceIn']

    # 참고: http://bost.ocks.org/mike/shuffle/
    shuffle = (array) ->
      m = array.length
      while m
        i = Math.floor(Math.random() * m--)
        t = array[m]
        array[m] = array[i]
        array[i] = t
      array

    resource.rangers.then (rangers) ->
      vm.rangers = shuffle(rangers).splice(0, 18)
      return

    animateLogo = ->
      nextTick = Math.floor(Math.random() * 5 + 5) * 1000
      $timeout ->
        vm.animateLogo = true
        animateLogo()
        $timeout ->
          delete vm.animateLogo
        , 3000
      , nextTick
      return

    animateRanger = ->
      nextTick = Math.floor(Math.random() * 10 + 5) * 1000
      $timeout ->
        for ranger in vm.rangers
          delete ranger.animate
        $timeout ->
          vm.rangers[Math.floor(Math.random() * vm.rangers.length)].animate = animations[Math.floor(Math.random() * animations.length)]
          animateRanger()
        , 100
      , nextTick
      return

    animateLogo()

    animateRanger()

    return