'use strict'

_ = require('lodash')
path = require('path')

# All configurations will extend these options
# ============================================
all =
  env: process.env.NODE_ENV

  # Root path of server
  root: path.normalize(__dirname + '/../../..')

  # Server port
  port: process.env.PORT or 7000

  # Should we populate the DB with sample data?
  seedDB: false

  # Secret for session, you will want to change this and make it an environment variable
  secrets:
    session: 'rangers-mighty'

  # List of user roles
  userRoles: [
    'guest'
    'user'
    'admin'
  ]

  # MongoDB connection options
  mongo:
    options:
      db:
        safe: true

  naver:
#    clientID: process.env.NAVER_ID or '6tyrMmP8dfHCtDLwPVzU'
#    clientSecret: process.env.NAVER_SECRET or '0UEj2Ayfv0'
    clientID: process.env.NAVER_ID or 'QL3AGh0SaRKsXaUz284q'
    clientSecret: process.env.NAVER_SECRET or '9Q9ZdXfETW'
    callbackURL: (process.env.DOMAIN or '') + '/auth/naver/callback'

# Export the config object based on the NODE_ENV
# ==============================================
# module.exports = _.merge(all, require('./' + process.env.NODE_ENV + '.js') or {})
module.exports = _.merge(all, require('./' + process.env.NODE_ENV) or {})