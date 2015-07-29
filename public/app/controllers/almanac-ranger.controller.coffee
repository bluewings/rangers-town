'use strict'

angular.module 'rangers'
.controller 'AlmanacRangerController', ($scope, resource) ->  

  vm = @

  compareNickname = (a, b) ->
    if a.nickname is b.nickname
      return if a.no is b.no
      if a.no > b.no
        return 1
      else
        return -1
    if a.nickname > b.nickname
      return 1
    else
      return -1

  resource.rangers.then (rangers) ->
    vm.rangers = []
    for ranger in rangers
      ranger.nickname = ranger.filename.replace(/^[^\-]+\-/, '').replace(/-thum.*$/, '')
      ranger.no = parseInt(ranger.filename.replace(/^u([0-9]+).*$/, '$1'), 10)
      if ranger.filename.search(/^u([0-9]+)e/) isnt -1
        ranger.no = ranger.no + 200
      vm.rangers.push ranger
    vm.rangers.sort(compareNickname)
    return

  return