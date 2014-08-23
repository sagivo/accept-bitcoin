http = require 'http'
bitcore  = require 'bitcore'
Key  = require './key'
Transaction  = require './transaction'
fs = require 'fs'
ee = require('events').EventEmitter

class Main
  settings =
    network: bitcore.networks.testnet #testnet / livenet
    password: 'enter_your_password_here'
    storePath: './keys.json'
    encryptPrivateKey: false
    payToAddress: 'n3CDcrQExa956Juv4jf5L59YNAxhKAWnMY'
    payReminderToAddress: null
    includeUnconfirmed: false
    checkTransactionEvery: 4000#(1000 * 60 * 10) #10 minutes
    checkTransactionMaxAttempts: 10
    minimumConfirmations: 1

  constructor: (address, o = {}) ->    
    return 'must have address' unless address
    ee.call(this)
    console.log 'hello ' + address
    @settings = extend(settings, o)
    
    key = new Key @settings, 'mnica1rWZbM6cRoMUy956DUAv6etDUszBR', 'cTauWUoGmuxARTVjgh8L7SJ9VtqsqbFacPXv4idJ27dwuPmF9djH'
    tx = new Transaction(key, @settings)
    #tx.checkBalance (err, d) =>
    tx.pushTx 'mookaUALkRngyevqAP6gyekqNBMtjoRJBm', transferAmount: '0.0001', (err, d) =>
      this.emit('foo', d)

extend = (object, properties) ->
  for key, val of properties
    object[key] = val
  object

Main.prototype.__proto__ = ee.prototype
module.exports = Main