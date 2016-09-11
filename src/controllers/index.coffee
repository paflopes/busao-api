{ BasicController } = require "./basicController"

module.exports = (app) ->
  new BasicController(app)