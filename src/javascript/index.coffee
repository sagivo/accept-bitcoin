http = require 'http'
bitcore  = require 'bitcore'
crypt  = require './encrypt'
Key  = require './key'
key = new Key()

class Main
  settings =
    network: bitcore.networks.livenet #testnet / livenet
    password: 'enter_your_password_here'

  constructor: (address, o = {}) ->
    return 'must have address' unless address
    console.log 'hello ' + address
    settings = extend(settings, o)
    run()

  run = ->
    key.createKeyPair(network: settings.network)

  store_keys = ->
    hw = crypt.encrypt("34c6eb9bbe7fe814f52af3007c12e0364752ed9afb508f8cd89d73f3b3e49710", settings.password)
    console.log hw
    console.log crypt.decrypt(hw, settings.password)

extend = (object, properties) ->
  for key, val of properties
    object[key] = val
  object


module.exports = Main