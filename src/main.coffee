express = require "express"
bodyParser = require "body-parser"
controllers = require "./controllers"

app = express()

app.use bodyParser.urlencoded({ extended: false })
app.use bodyParser.json({})

controllers(app)

app.get "/", (req, res) ->
  res.send 'Hello World!'

PORT = process.env.PORT || 3000
app.listen PORT, () ->
  console.log("Busao API running on port #{PORT}!")
