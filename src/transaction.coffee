bitcore  = require 'bitcore'
request = require 'request'

class Transaction
  constructor: (@settings) ->
 
  #must = payToAddress | options = transferAmount, payReminderToAddress
  #response: err, { status: 'success', data: 'effdd4d2985361c69f078d45ba49ec9b91f049336432b644dc73fda3e92000f1', code: 200, message: '' }
  pushTx: (payToAddress, o = {}, cb) =>
    @transferPaymentHash payToAddress, o, (err, hex) =>
      request.post url: "http://#{if @settings.network == bitcore.networks.testnet then 't' else ''}btc.blockr.io/api/v1/tx/push", json: {hex: hex}, (error, response, body) =>
        cb err, body

module.exports = Transaction  