request = require 'request-promise'
{ Controller } = require "./controller"

class BasicController extends Controller
  constructor: (@url) ->
    super()

  route: ->
    @router.get '/controller', @obterLinhas
    @router.get '/linha/:numero', @getLinha

  obterLinhas: (req, res) =>
    request(@url).then (json) =>
      @linhas = JSON.parse json
      res.send { sucesso: yes }

  getLinha: (req, res) =>
    linha = { numero: '', nome: '', caminho: { ida: [], volta: [] } }

    if @linhas
      numero = req.params.numero
      numero = "0#{numero}" if numero.length == 3

      linha = @linhas.find (el) -> el.numero == numero

    res.send linha

module.exports = { BasicController }
