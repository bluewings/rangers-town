'use strict'

angular.module 'rangers'
.directive 'loginBox', ->
  restrict: 'E'
  replace: true
  templateUrl: 'app/directives/login-box.directive.html'
  scope:
    user: '=user'
    character: '=character'
  bindToController: true
  controllerAs: 'vm'
  controller: ($scope, Auth) ->
    vm = @

    vm.character = vm.user.character if vm.user

    vm.auth =
      logout: ->
        Auth.logout()
        vm.user = null

    return