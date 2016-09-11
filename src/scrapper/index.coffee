request = require "request-promise"
cheerio = require "cheerio"
iconv = require "iconv-lite"
Promise = require "bluebird"

class Scraper
  constructor: () ->
    @ITINERARIO = 15981
    @ceturbUrl = "http://www.ceturb.es.gov.br/default.asp"
    @$ = null
    @initializePromise = null

  _requestCeturb: (form) ->
    chunks = []
    decodedBody = ''

    request
      uri: @ceturbUrl
      method: "POST"
      form: form
    .on 'data', (chunk) -> chunks.push chunk
    .on 'end', () ->
      decodedBody = iconv.decode(Buffer.concat(chunks), 'win1252')
    .then () ->
      decodedBody

  _getLinhas: (select) ->
    @initializePromise.then ($) ->
      actions = []

      $("##{select}").find('option').each (index, el) ->
        actions.push($(el).text())

      actions = actions.map (el) ->
        linha = el.split ' - '
        { numero: linha[0], nome: linha[1] }

      Promise.all(actions)

  _getCaminho: (linha, pag) ->
    @_requestCeturb
      ItemMenu: 'adm500.asp'
      PaginaDestino: "adm500_#{pag}.asp"
      quallinha: linha
    .then (body) ->
      body = cheerio.load(body, { decodeEntities: true })('.roteiro').text()

      regexIda =
        bloco: /ida[\s\S]*(?=volta)/gi
        list: /(?!ida)^.*?(\S.*?)\s*$/gmi

      regexVolta =
        bloco: /volta[\s\S]*/gi
        list: /(?!volta)^.*?(\S.*?)\s*$/gmi

      caminho = { ida: [], volta: [] }

      ida = regexIda.bloco.exec(body)[0]
      volta = regexVolta.bloco.exec(body)[0]

      while ((x = regexIda.list.exec(ida)) != null)
        caminho.ida.push x[1]

      while ((x = regexVolta.list.exec(volta)) != null)
        caminho.volta.push x[1]

      caminho

  initialize: () ->
    @initializePromise = @_requestCeturb
      ItemMenu: @ITINERARIO
      Parametro: ""
      PaginaDestino: ""
      hidCdPublicacao: ""
    .then (body) =>
      @$ = cheerio.load(body, { decodeEntities: true })

  getSeletivosStrings: () ->
    @_getLinhas('select1')

  getTranscolStrings: () ->
    @_getLinhas('select2')

  getCaminhoSeletivo: (linha) ->
    @_getCaminho(linha, '1')

  getCaminhoTranscol: (linha) ->
    @_getCaminho(linha, '2')

  criarLinhas: () ->
    actions = []

    @getSeletivosStrings().then (seletivos) =>
      seletivos.forEach (seletivo) =>
        actions.push @getCaminhoSeletivo(seletivo.numero).then((caminho) ->
          numero: seletivo.numero
          nome: seletivo.nome
          caminho: caminho
        )

    .then () => @getTranscolStrings()
    .then (transcol) =>
      transcol.forEach (linha) =>
        actions.push @getCaminhoTranscol(linha.numero).then((caminho) ->
          numero: linha.numero
          nome: linha.nome
          caminho: caminho
        )

      Promise.all actions
