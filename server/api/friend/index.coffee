'use strict'

express = require('express')
controller = require('./friend.controller')
config = require('../../config/environment')
auth = require('../../auth/auth.service')

router = express.Router()

router.get '/', auth.isAuthenticated(), controller.index
router.delete '/:id', auth.isAuthenticated(), controller.destroy
router.post '/:id', auth.isAuthenticated(), controller.create

module.exports = router