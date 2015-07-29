'use strict'

app = angular.module 'rangers'

app.factory 'User', ($resource, $modal) ->
  User = $resource '/api/users/:id/:controller',
    id: '@_id'
  ,
    get:
      method: 'GET'
      params:
        id: 'me'
    update:
      method: 'PUT'

  User::modal = ->
    my = @
    $modal.open
      templateUrl: 'app/services/user-modal.controller.html'
      size: 'md'
      windowClass: 'user-modal-controller'
      controller: 'UserModalController'
      controllerAs: 'vm'
      bindToController: true
      resolve:
        user: ->
          my
        rangers: (resource) ->
          resource.rangers

  User::rank_modal = ->
    my = @
    console.log my
    $modal.open
      templateUrl: 'app/services/rank-modal.controller.html'
      size: 'md'
      windowClass: 'rank-modal-controller'
      controller: 'RankModalController'
      controllerAs: 'vm'
      bindToController: true
      resolve:
        user: ->
          my.getall
        rangers: (resource) ->
          resource.rangers
        users: ($q, User) ->
          deferred = $q.defer()
          User.query (users) ->
            deferred.resolve users
          , (err) ->
            deferred.reject err
          deferred.promise
  User