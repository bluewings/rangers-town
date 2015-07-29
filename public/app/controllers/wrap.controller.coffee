'use strict'

angular.module 'rangers'
.controller 'WrapController', ($scope, $rootScope, $interval, Auth, Friend) ->
  vm = @

  updateUser = ->
    Auth.getCurrentUserAsync()
    .then (user) ->
      vm.user = user
      unless user
        vm.friends = []
      return
    return

  updateFriends = ->
    Friend.query (friends) ->
      vm.friends = friends
    return

  $scope.$on 'loginStateChange', ->
    updateUser()
    return

  updateUser()

  updateFriends()

  unbind = $interval ->
    updateFriends()
    return
  , 60 * 1000

  $scope.$on '$destroy', ->
    try unbind()
    return

  return
 