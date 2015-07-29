'use strict'

angular.module 'rangers'
.factory 'Auth', ($state, $rootScope, $http, User, $cookieStore, $q) ->  
  currentUser = if $cookieStore.get 'token' then User.get() else {}

  # Authenticate user and save token
  login: (user, callback) ->
    deferred = $q.defer()
    $http.post '/auth/local',
      email: user.email
      password: user.password
    .success (data) ->
      $cookieStore.put 'token', data.token
      currentUser = User.get()
      $rootScope.$broadcast 'loginStateChange'
      deferred.resolve data
      callback?()
    .error (err) =>
      @logout()
      deferred.reject err
      callback? err
    deferred.promise

  # Delete access token and user info
  logout: (callback) ->
    $cookieStore.remove 'token'
    currentUser = {}
    $rootScope.$broadcast 'loginStateChange'
    if callback
      callback()
    else
      $state.go 'front'
    return

  # Create a new user
  createUser: (user, callback) ->
    User.save user,
      (data) ->
        $cookieStore.put 'token', data.token
        currentUser = User.get()
        callback? user
      , (err) =>
        @logout()
        callback? err
    .$promise

  # Change password
  changePassword: (oldPassword, newPassword, callback) ->
    User.changePassword
      id: currentUser._id
    ,
      oldPassword: oldPassword
      newPassword: newPassword
    , (user) ->
      callback? user
    , (err) ->
      callback? err
    .$promise

  # Gets all available info on authenticated user
  getCurrentUser: ->
    currentUser

  getCurrentUserAsync: (callback) ->
    deferred = $q.defer()
    @isLoggedInAsync (loggedIn) ->
      if loggedIn
        deferred.resolve currentUser
        callback?(currentUser)
      else
        deferred.resolve null
        callback?(null)
      return
    deferred.promise

  # Check if a user is logged in synchronously
  isLoggedIn: ->
    currentUser.hasOwnProperty 'role'

  # Waits for currentUser to resolve before checking if user is logged in
  isLoggedInAsync: (callback) ->
    if currentUser.hasOwnProperty '$promise'
      currentUser.$promise.then ->
        callback? true
        return
      .catch ->
        callback? false
        return
    else
      callback? currentUser.hasOwnProperty 'role'

  # Check if a user is an admin
  isAdmin: ->
    currentUser.role is 'admin'

  # Get auth token
  getToken: ->
    $cookieStore.get 'token'
