http = require 'http'
bitcore  = require 'bitcore'
Key  = require './key'
Transaction  = require './transaction'
fs = require 'fs'
crypt  = require './encrypt'
ee = require('events').EventEmitter

class Main
  settings =
    network: 'test' #test / live
    password: 'enter_your_password_here'
    storePath: './keys.txt' #null if no need to store
    encryptPrivateKey: false
    payToAddress: 'PUT_YOUR_ADDRESS_HERE'
    payReminderToAddress: null
    includeUnconfirmed: false
    checkTransactionEvery: (1000 * 60 * 2) #2 minutes dev: 5000
    checkBalanceTimeout: (1000 * 60 * 60 * 2) #60 minutes timeout --remove
    checkUnspentTimeout: (1000 * 60 * 60 * 2) #60 minutes timeout
    minimumConfirmations: 1
    txFee: 0.0001

  constructor: (address, o = {}) ->
    return 'must have address' unless address
    ee.call(this)
    console.log 'hello ' + address
    @settings = extend(settings, o)

  generateAddress: (o, privateKey) =>
    if privateKey
      key = new Key settings, o, privateKey
    else
      key = new Key extend(settings, o)
    key.checkBalance() if o and o.alertWhenHasBalance
    key

  encrypt: (s) =>
    crypt.encrypt s, @settings.password
    
  decrypt: (s) =>
    crypt.decrypt s, @settings.password


extend = (object, properties) ->
  for key, val of properties
    object[key] = val
  object

Main.prototype.__proto__ = ee.prototype
module.exports = Main