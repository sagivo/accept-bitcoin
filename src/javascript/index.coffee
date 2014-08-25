http = require 'http'
bitcore  = require 'bitcore'
Key  = require './key'
Transaction  = require './transaction'
Key  = require './key'
fs = require 'fs'
ee = require('events').EventEmitter

class Main
  settings =
    network: bitcore.networks.testnet #testnet / livenet
    password: 'enter_your_password_here'
    storePath: './keys.json'
    encryptPrivateKey: false
    payToAddress: 'muVxU1ZH4yLbV9FrjD3WXv5bzD2JChSkhw'
    payReminderToAddress: null
    includeUnconfirmed: false
    checkTransactionEvery: 5000 #(1000 * 60 * 2) #2 minutes
    checkBalanceTimeout: (1000 * 60 * 60) #60 minutes timeout --remove
    checkUnspentTimeout: (1000 * 60 * 60) #60 minutes timeout
    checkTransactionMaxAttempts: 10
    minimumConfirmations: 1
    txFee: 0.0001

  constructor: (address, o = {}) ->    
    return 'must have address' unless address
    ee.call(this)
    console.log 'hello ' + address
    @settings = extend(settings, o)
    #key = new Key @settings, 'mnica1rWZbM6cRoMUy956DUAv6etDUszBR', 'cTauWUoGmuxARTVjgh8L7SJ9VtqsqbFacPXv4idJ27dwuPmF9djH'
    #tx = new Transaction(key, @settings)
    #tx.checkBalance (err, d) =>
    #tx.pushTx 'mookaUALkRngyevqAP6gyekqNBMtjoRJBm', transferAmount: '0.0001', (err, d) =>
    #  this.emit('foo', d)

  generateAddress: (set) =>
    key = new Key @settings#, 'mnica1rWZbM6cRoMUy956DUAv6etDUszBR', 'cTauWUoGmuxARTVjgh8L7SJ9VtqsqbFacPXv4idJ27dwuPmF9djH'
    key.checkBalance() if set.alertWhenHasBalance      
    key

extend = (object, properties) ->
  for key, val of properties
    object[key] = val
  object

Main.prototype.__proto__ = ee.prototype
module.exports = Main