'use strict'

angular.module 'rangers', [
  'ngAnimate'
  'ngCookies'
  'ngResource'
  'ngSanitize'
  'ui.bootstrap'
  'ui.router'
  'angular-jwt'
  'btford.socket-io'
  # 'alAngularHero'
  'schemaForm'
  'config'
]
.config ($urlRouterProvider, $stateProvider, $httpProvider, $provide, jwtInterceptorProvider) ->

  # set JWT token
  $httpProvider.interceptors.push 'jwtInterceptor'
  jwtInterceptorProvider.tokenGetter = ($cookieStore) ->
    $cookieStore.get 'token'

  $provide.decorator '$state', ($delegate, $rootScope) ->
    $rootScope.$on '$stateChangeStart', (event, toState, toParams) ->
      $delegate.next = toState
      return
    $delegate

  $urlRouterProvider.otherwise '/'

  $stateProvider.state 'wrap',
    abstract: true
    templateUrl: 'app/controllers/wrap.controller.html'
    controller: 'WrapController'
    controllerAs: 'vm'

  $stateProvider.state 'front',
    url: '/'
    parent: 'wrap'
    templateUrl: 'app/controllers/front.controller.html'
    controller: 'FrontController'
    controllerAs: 'vm'
    resolve:
      user: (Auth) ->
        Auth.getCurrentUserAsync()

      rangers: (resource) ->
        resource.rangers

      stages: (resource) ->
        resource.stages

  $stateProvider.state 'lounge',
    url: '/lounge'
    parent: 'wrap'
    templateUrl: 'app/controllers/lounge.controller.html'
    controller: 'LoungeController'
    controllerAs: 'vm'
    resolve:
      me: ($q, mySocket) ->
        deferred = $q.defer()
        mySocket.emit 'room.join', 'lobby', (err, room) ->
          if err 
            alert err
            deferred.reject null
          else
            deferred.resolve mySocket.stat.me
          return
        deferred.promise

      user: (Auth) ->
        Auth.getCurrentUserAsync()

      friends: (Friend) ->
        Friend.query()

      rangers: (resource) ->
        resource.rangers

      stages: (resource) ->
        resource.stages

      games: (Game) ->
        Game.query()

  $stateProvider.state 'profile',
    url: '/profile'
    templateUrl: 'app/controllers/profile.controller.html'
    controller: 'ProfileController'
    controllerAs: 'vm'
    resolve:
      user: (Auth) ->
        Auth.getCurrentUserAsync()

      rangers: (resource) ->
        resource.rangers

      stages: (resource) ->
        resource.stages

  $stateProvider.state 'sample',
    url: '/sample/directive'
    parent: 'wrap'
    templateUrl: 'app/controllers/sample-directive.controller.html'
    controller: 'SampleDirectiveController'
    controllerAs: 'vm'
    resolve:
      user: (Auth) ->
        Auth.getCurrentUserAsync()

  $stateProvider.state 'sample-layout',
    url: '/sample/layout'
    parent: 'wrap'
    templateUrl: 'app/controllers/sample-layout.controller.html'
    controller: 'SampleLayoutController'
    controllerAs: 'vm'
    resolve:
      user: (Auth) ->
        Auth.getCurrentUserAsync()

  $stateProvider.state 'almanac',
    url: '/almanac/ranger'
    parent: 'wrap'
    templateUrl: 'app/controllers/almanac-ranger.controller.html'
    controller: 'AlmanacRangerController'
    controllerAs: 'vm'

  $stateProvider.state 'nameplate',
    url: '/nameplate'
    templateUrl: 'app/controllers/nameplate.controller.html'
    controller: 'NameplateController'
    controllerAs: 'vm'
    resolve:
      user: (Auth) ->
        Auth.getCurrentUserAsync()

  # define game state
  onmessage =
    listeners: {}
    callback: (eventName, message) ->
      args = []
      for arg in arguments
        args.push arg
      eventName = args.shift()
      if onmessage.listeners[eventName]
        for listener in onmessage.listeners[eventName]
          listener.apply null, args
      return

  onchat =
    messages: []
    callback: (message) ->
      onchat.messages.push message
      return


  for game in games
    $stateProvider.state "#{game.id}-game",
      url: "/games/#{game.id}/{roomId:[A-Za-z0-9\-]+}"
      parent: 'wrap'
      templateUrl: game.template
      controller: game.controller
      controllerAs: 'vm'
      game: true
      resolve:
        me: ($q, $state, $stateParams, mySocket) ->
          deferred = $q.defer()
          mySocket.emit 'room.join', 
            gameId: $state.next.name.replace(/-game$/, '')
            roomId: $stateParams.roomId
          , (err, room) ->
            if err 
              alert err
              $state.go 'lounge'
              deferred.reject null
            else
              deferred.resolve mySocket.stat.me
            return
          deferred.promise

        rangers: (resource) ->
          resource.rangers

        stages: (resource) ->
          resource.stages

        socket: (mySocket) ->
          onmessage.listeners = {}
          try mySocket.removeListener '__message__', onmessage.callback
          mySocket.on '__message__', onmessage.callback
          socket = 
            emit: (eventName, message) ->
              args = ['__message__']
              for arg in arguments
                args.push arg
              mySocket.emit.apply mySocket, args
              return
            on: (eventName, callback) ->
              unless onmessage.listeners[eventName]
                onmessage.listeners[eventName] = []
              onmessage.listeners[eventName].push callback
              return
          socket

        chat: (mySocket) ->
          onchat.messages = []
          try mySocket.removeListener 'message', onchat.callback
          mySocket.on 'message', onchat.callback
          chat =
            messages: onchat.messages
            send: (message) ->

              mySocket.emit 'message', message

          chat

  return


.run ($rootScope, $state, $window, $timeout, $http, Auth, Game, mySocket) ->

  resizeHandler = ->
    $rootScope.clientWidth = document.documentElement.clientWidth
    $rootScope.clientHeight = document.documentElement.clientHeight
    return

  resizeHandler()

  $($window).on 'resize', (event) ->
    $timeout resizeHandler
    return

  $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
    transition = ''
    fromName = fromState.name
    toName = toState.name

    if fromName is 'front'
      if toName is 'lounge'
        transition = 'slide-left'

    if fromName is 'lounge'
      if toName is 'front'
        transition = 'slide-right'
      else if toName.search(/\-game$/) isnt -1
        transition = 'slide-up'
      # else if toName is 'lobby'
      #   transition = 'slide-down'
      else if toName is 'profile'
        transition = 'slide-down'

    if fromName.search(/\-game$/) isnt -1
      if toName is 'lounge'
        transition = 'slide-down'

    if fromName is 'profile'
      if toName is 'lounge'
        transition = 'slide-up'

    if fromName is 'lobby'
      if toName is 'lounge'
        transition = 'slide-up'

    $rootScope.transition = transition

  $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
    # console.log 'check 1 : ' + $('[ui-view] [hero]').size()
    Auth.isLoggedInAsync (loggedIn) ->
      if toState.authenticate and not loggedIn
        event.preventDefault()
        Auth.logout -> $state.go 'home'
      else
        # console.log 'check 2 : ' + $('[ui-view] [hero]').size()
      return
    return

  $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->

    $timeout ->
      $rootScope.current = toState
      $rootScope.stateParams = toParams
      # console.log toState

    # console.log 'check 3 : ' + $('[ui-view] [hero]').size()
    return

  # hero = null
  heroes = {}

  $rootScope.$on '$viewContentLoading', ->
    return

    heroes = {}

    $('[ui-view]').attr('expired-view', 1)
    $('[ui-view] [hero]').each (index, item) ->


      name = item.getAttribute('hero')
      $(item).parents('[ui-view]').attr('expired-view', 1)
      heroes[name] = 
        clone: $(item).clone()
        rect: item.getBoundingClientRect()
      # # console.log name

      



    # console.log '>> we are heroes'
    # console.log heroes



    # if hero
    #   cloned =
    #     el: hero.clone()
    #     name

    # else
    #   cloned = null
      
    # # console.log 'check 4 ui-view : ' + $('[ui-view]').size()
    # # console.log 'check 4 hero : ' + $('[ui-view] [hero]').size()


  $rootScope.$on '$viewContentLoaded', ->
    $('[ui-view]').each (index, item) ->

      item = $(item)
      return if item.attr('expired-view')

      item.find('[hero]').each (i, hero) ->
        name = hero.getAttribute('hero')
        
        if heroes[name]
          # console.log '%chero found.', 'font-size:20px'

          elemId = "hero-#{name}"

          $("##{elemId}").remove()

          $(document.body).append heroes[name].clone
          rect = heroes[name].rect

          heroes[name].clone.attr
            id: elemId
          .css
            position: 'absolute'
            top: 0
            left: 0
            zIndex: 10000
            transform: "translateX(#{rect.left}px) translateY(#{rect.top}px)"

          rect = hero.getBoundingClientRect()
          heroes[name].clone.css
            transition: 'all .75s ease-in-out'
            transform: "translateX(#{rect.left}px) translateY(#{rect.top}px)"
          
          clone = heroes[name].clone
          heroes[name].clone.one 'transitionend', ->
            clone.remove()



          # console.log "translateX(#{rect.left}px)"


      heroes = {}


      # # console.log 'valid view!!!'


    # .attr('expired-view', 1)
    # # console.log 'check 5 ui-view : ' + $('[ui-view]').size()
    # # console.log 'check 5 hero : ' + $('[ui-view] [hero]').size()

  return

Array::shuffle = ->
  i = @length
  j = undefined
  temp = undefined
  if i == 0
    return this
  while --i
    j = Math.floor(Math.random() * (i + 1))
    temp = @[i]
    @[i] = @[j]
    @[j] = temp
  this