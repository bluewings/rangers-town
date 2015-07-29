'use strict'

angular.module 'rangers'
.filter 'momentFromNow', ->
  (value) -> moment(value).fromNow()
