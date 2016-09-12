{ BasicController } = require "./basicController"

url = 'https://gist.github.com/paflopes/e16ce409ae89a4f4c15f529b6dbe7fe1/raw/\
1195a6ca7cc9fba3aad43bdc34b49c44b9d65494/linhas.json'

module.exports = (app) ->
  app.use '/', new BasicController(url).route()