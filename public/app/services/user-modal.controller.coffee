'use strict'

angular.module 'rangers'
.controller 'UserModalController', ($scope, $modalInstance, rangers, user) ->
  vm = @
  vm.modalInstance = $modalInstance

  vm.user = user
  vm.snapshot = JSON.stringify vm.user

  vm.close = ->
    $modalInstance.dismiss()
    return

  vm.shuffleRanger = ->
    vm.user.character = rangers[Math.floor(Math.random() * rangers.length)].filename
    return

  vm.update = ->
    console.log 'update'
    user.$update (user) ->
      $modalInstance.close(user)
      return
    , (err) ->
      alert err
      return
    return


  $scope.$watch 'vm.user', (user) ->
    vm.current = JSON.stringify user
  , true

  return