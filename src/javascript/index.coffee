http = require 'http'
bitcore  = require 'bitcore'
Key  = require './key'
key = new Key()

class Main
  settings =
    network: bitcore.networks.livenet #testnet / livenet

  constructor: (address, o = {}) ->
    return 'must have address' unless address
    console.log 'hello ' + address
    settings = extend(settings, o)        
    run()

  run = ->
    key.createKeyPair(network: settings.network)

extend = (object, properties) ->
  for key, val of properties
    object[key] = val
  object


module.exports = Main