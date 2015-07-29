'use strict'

angular.module 'rangers'
.controller 'FrontController', ($scope, $timeout, user) ->  
  vm = @

  vm.user = user

  vm.cards = []

  vm.player1Cards = []
  vm.player2Cards = []
  vm.player3Cards = []
  vm.player4Cards = []

  for i in [0...30]
    vm.cards.push num: i

  # index = 0
  vm.spread = ->

    if vm.cards.length > 0


      card = vm.cards.pop()
      index = vm.cards.length % 4
      # console.log card
      if index is 0
        vm.player1Cards.push card
      if index is 1
        vm.player2Cards.push card
      if index is 2
        vm.player3Cards.push card
      if index is 3
        vm.player4Cards.push card

      $timeout ->
        vm.spread()
      , 50



  vm.upItems = [
    { name: 'Albert' }
    { name: 'Mike' }
    { name: 'Luke' }
    { name: 'Elsa' }
    { name: 'Sam' }
    { name: 'Poong' }
    { name: 'Lee' }
  ]


  vm.downItems = []

  vm.moveItem = (dir = 'down') ->
    if dir is 'down'
      fromItems = vm.upItems
      toItems = vm.downItems
    else
      fromItems = vm.downItems
      toItems = vm.upItems

    if fromItems.length > 0
      index = Math.floor(Math.random() * fromItems.length)
      toItems.push fromItems.splice(index, 1)[0]
    if fromItems.length > 0
      index = Math.floor(Math.random() * fromItems.length)
      toItems.push fromItems.splice(index, 1)[0]
    return

  return