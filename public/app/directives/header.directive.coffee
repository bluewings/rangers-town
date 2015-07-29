'use strict'

angular.module 'rangers'
.directive 'rangersHeader', ->
  restrict: 'E'
  replace: true
  templateUrl: 'app/directives/header.directive.html'
  scope:
    user: '=user'
    friends: '=friends'
  bindToController: true
  controllerAs: 'vm'
  controller: ($scope, $rootScope, Auth, User, mySocket) ->
    vm = @

    vm.friendImages = []
    vm.socketStat = mySocket.stat

    vm.current = ->
      $rootScope.current

    vm.roomName = ->
      current = vm.current()
      if $rootScope.stateParams and $rootScope.stateParams.roomId
        room = mySocket.stat.rooms[$rootScope.stateParams.roomId]
      if room
        return room.gameId + ' - ' + room.name
      if current.name is 'lounge'
        return '라운지'
      else if current.name is 'sample'
        return 'API 문서 : DIRECTIVES'
      else if current.name is 'sample-layout'
        return 'API 문서 : LAYOUT'
      else if current.name is 'almanac'
        return '레인저 연감'
      else if current.name is 'front'
        return '환영합니다'
      return current.name

    vm.auth = 
      logout: Auth.logout

    vm.openUserModal = ->
      # 현재 인스턴스와 편집 중인 인스턴스를 분리하기 위해 재호출한다.
      User.get (user) ->
        user.modal()
      return
      user.modal().result.then (updatedUser) ->
        vm.user = updatedUser
        return
      return

    vm.openRankModal = ->
      User.get (user) ->
        user.rank_modal()
      return

    return