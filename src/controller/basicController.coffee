{ Controller } = require "./controller"

class BasicController extends Controller
  constructor: (@app) ->
    super(@app)

  route: ->
    @app.get '/controller', @getDefault

  getDefault: (req, res) ->
    res.send('controller.getDefault')

module.exports = { BasicController }
