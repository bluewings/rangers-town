'use strict'

angular.module 'rangers'
.controller 'NameplateController', ($scope, user) ->  
  vm = @

  vm.user = user


  vm.toggleFold = ->
    if vm.fold
      delete vm.fold
    else
      vm.fold = true
    return

  # setTimeout ->
  #   window.print()
  # , 1000
    
  return