'use strict'

angular.module 'rangers'
.controller 'RankModalController', ($scope, $modalInstance, rangers, user, users) ->
  vm = @
  vm.modalInstance = $modalInstance
  vm.user = user;
  vm.ranking = []

  compareRanking = (a, b) ->
    if a.score is undefined
      a.score = 0
    if b.score is undefined
      b.score = 0
    if a.score is b.score
      return 0
    if a.score < b.score
      return 1
    else
      return -1

  sortPlayers = []
  for u in users
    sortPlayers.push u

  sortPlayers.sort compareRanking

  i = 0
  rank = 1
  preScore = sortPlayers[0].score

  sortPlayers[0].rank=rank;
  for u in sortPlayers
    i++
    if(preScore > u.score)
      console.log {'presScore': preScore, 'nowscore' : u.score}
      rank = i

    u.ranking = rank
    preScore = u.score

  vm.rankers=sortPlayers;

  vm.close = ->
    $modalInstance.dismiss()
    return

  return