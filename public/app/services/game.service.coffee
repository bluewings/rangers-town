'use strict'

angular.module 'rangers'
.factory 'Game', ($resource, $modal) ->
  Game = $resource '/api/games/:id',
    id: '@id'

  Game.modal = ->
    my = @
    $modal.open
      templateUrl: 'app/services/game-modal.controller.html'
      size: 'md'
      windowClass: 'game-modal-controller'
      controller: 'GameModalController'
      controllerAs: 'vm'
      bindToController: true
      resolve:
        user: (Auth) ->
          Auth.getCurrentUserAsync()

        games: ($q, Game) ->
          deferred = $q.defer()
          Game.query (games) ->
            deferred.resolve games
          , (err) ->
            deferred.reject err
          deferred.promise

  Game
