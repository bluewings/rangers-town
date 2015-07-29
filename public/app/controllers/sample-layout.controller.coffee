'use strict'

angular.module 'rangers'
.filter 'smallerSize', ->
  sizes = ['xs', 'sm', 'md', 'lg', 'xl']
  (value) ->
    index = sizes.indexOf(value)
    return if index > 0 then sizes[index - 1] else sizes[0]

.filter 'biggerSize', ->
  sizes = ['xs', 'sm', 'md', 'lg', 'xl']
  (value) ->
    index = sizes.indexOf(value)
    return if index + 1 > sizes.length then sizes[index + 1] else sizes[sizes.length - 1]

.controller 'SampleLayoutController', ($scope, $timeout, user, resource) ->  
  vm = @

  vm.sizes = ['sm', 'md', 'lg', 'xl']

  vm.layout =

    client: user
    num: 5
    mySize: 'xl'
    myType: 'horizontal'
    myValign: 'middle'
    otherSize: 'md'
    otherType: ''
    otherValign: ''
    options:
      nums: [2, 3, 4, 5]
      # 750px 970px 1170px
      # 710px 940px 1130px
      # 부트 스트랩 기존으로 쪼개면 단계간의 차이가 너무 커서 940을 기준으로 100px 단위로 변경

      # 740, 840 ,940, 1040, 1140
      frameSizes: ['sm', 'md', 'lg', 'xl', 'xxl']
      mySizes: ['sm', 'md', 'lg', 'xl']
      myTypes: ['vertical', 'horizontal']
      myValigns: ['top', 'middle', 'bottom']
      otherSizes: ['sm', 'md', 'lg', 'xl']
      otherTypes: ['vertical', 'horizontal']
      otherValigns: ['top', 'middle', 'bottom']
    set: (name, value) ->
      if vm.layout[name] is value
        vm.layout[name] = ''
      else
        vm.layout[name] = value
      return

  vm.player =
    client: user
    show: ''
    options:
      valigns: ['top', 'middle', 'bottom']
    set: (name, value) ->
      if vm.player[name] is value
        vm.player[name] = ''
      else
        vm.player[name] = value
      return
    random: ->
      resource.rangers.then (rangers) ->
        vm.player.client.character = rangers[Math.floor(Math.random() * rangers.length)].filename

  unless user
    resource.rangers.then (rangers) ->
      vm.player.client =
        character: rangers[Math.floor(Math.random() * rangers.length)].filename

  vm.toggleRanger = ->

  return