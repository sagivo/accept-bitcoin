http = require 'http'
bitcore  = require 'bitcore'
Key  = require './key'
Transaction  = require './transaction'
Key  = require './key'
fs = require 'fs'
ee = require('events').EventEmitter

class Main
  settings =
    network: 'test' #test / live
    password: 'enter_your_password_here'
    storePath: './keys.json' #null if no need to store
    encryptPrivateKey: false
    payToAddress: 'PUT_YOUR_ADDRESS_HERE'
    payReminderToAddress: null
    includeUnconfirmed: false
    checkTransactionEvery: (1000 * 60 * 2) #2 minutes dev: 5000
    checkBalanceTimeout: (1000 * 60 * 60 * 2) #60 minutes timeout --remove
    checkUnspentTimeout: (1000 * 60 * 60 * 2) #60 minutes timeout
    minimumConfirmations: 1
    txFee: 0 #0.0001

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

  generateAddress: (o) =>
    key = new Key extend(settings, o)#, 'mx5nzg1tRwADWDCU53CSHmY7iac2f4B2YK', 'cUWFtYbNycND7wQ9QZKPimkrKQoU9uYJ8M1nyV7W24bXaVdPhTtQ'
    key.checkBalance() if o.alertWhenHasBalance
    key

extend = (object, properties) ->
  for key, val of properties
    object[key] = val
  object

Main.prototype.__proto__ = ee.prototype
module.exports = Main