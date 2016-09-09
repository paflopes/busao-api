express = require "express"
bodyParser = require "body-parser"

app = express()

app.use bodyParser.urlencoded({ extended: false })
app.use bodyParser.json({})

{ BasicController } = require('./controller/basicController')

controller = new BasicController(app)

app.get "/", (req, res) ->
  res.send 'Hello World!'

PORT = process.env.PORT || 3000
app.listen PORT, () ->
  console.log("Busao API running on port #{PORT}!")
