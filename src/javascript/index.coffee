http = require 'http'
bitcore  = require 'bitcore'
Key  = require './key'
Transaction  = require './transaction'
fs = require 'fs'
ee = require('events').EventEmitter

class Main
  settings =
    network: bitcore.networks.livenet #testnet / livenet
    password: 'enter_your_password_here'
    storePath: './keys.json'
    encryptPrivateKey: false
    payToAddress: 'nulssdl'
    checkTransactionEvery: 1000#(1000 * 60 * 10) #10 minutes
    checkTransactionMaxAttempts: 10
    minimumConfirmations: 6

  constructor: (address, o = {}) ->    
    return 'must have address' unless address
    ee.call(this)
    console.log 'hello ' + address
    @settings = extend(settings, o)
    
    tx = new Transaction(@settings)
    tx.checkBalance '14nsgXjL7xCEXFf8UkGCm9KnSTTFBDKqcn', (err, d) =>
      console.log err,d
      this.emit('foo', 'found!')
    #generateKey()

  generateKey: ->
    key = new Key(settings)
    key.address()

  paymentRequest: (params, cb) ->
    key = @generateKey()
    
    cb(null, settings.payToAddress)

  #store_keys = ->
    #hw = crypt.encrypt("34c6eb9bbe7fe814f52af3007c12e0364752ed9afb508f8cd89d73f3b3e49710", settings.password)
    #console.log hw
    #console.log crypt.decrypt(hw, settings.password)    


extend = (object, properties) ->
  for key, val of properties
    object[key] = val
  object

Main.prototype.__proto__ = ee.prototype
#util.inherits(Main, ee)

module.exports = Main