bitcore  = require 'bitcore'
request = require 'request'

class Transaction
  constructor: (@key, @settings) ->
  
  #options = address, includeUnconfirmed #todo
  checkBalance: (o, @cb) ->
    address = o.address || @key.address()
    includeUnconfirmed = o.includeUnconfirmed || @settings.includeUnconfirmed
    @cb = o if o instanceof Function
    @checkBalanceInterval = setInterval(@getUnspent(address, includeUnconfirmed), @settings.checkTransactionEvery)
    
  getUnspent: (address, includeUnconfirmed) =>
    console.log 'checking'
    if (@settings.checkTransactionMaxAttempts -= 1) < 0
      clearInterval @checkBalanceInterval
      @cb('maxAttempts'); return
    request.get "http://#{if @settings.network == bitcore.networks.testnet then 't' else ''}btc.blockr.io/api/v1/address/unspent/#{address}#{ if includeUnconfirmed then '?unconfirmed=1' else '' }", (error, response, body) =>
      body = JSON.parse(body) 
      return null unless body.status == 'success' and body.data?.unspent?.length > 0
      clearInterval @checkBalanceInterval     
      unspent = (@uotxToHash(body.data.address, tx) for tx in body.data.unspent when tx.confirmations >= @settings.minimumConfirmations)      
      @cb null, unspent if @cb

  #must = payToAddress | options = transferAmount, payReminderToAddress
  transferPaymentHash: (payToAddress, o = {}, cb) =>
    return cb('must have payToAddress') unless payToAddress
    @checkBalance address: @key.address(), (err, unspent) =>
      transferAmount = o.transferAmount || unspent.reduce ((tot, o) -> tot + parseFloat(o.amount)),0    
      outs = [{address: payToAddress, amount: transferAmount}]
      options = remainderOut: address: o.payReminderToAddress || @settings.payReminderToAddress || @key.address()      
      #console.log "building options: ", options, "unspent:", unspent, "outs:", outs, "sign:",@key.privateKey()
      tx = new bitcore.TransactionBuilder(options).setUnspent(unspent).setOutputs(outs).sign([@key.privateKey()]).build()
      txHex = tx.serialize().toString('hex')
      cb null, txHex

  #must = payToAddress | options = transferAmount, payReminderToAddress
  #response: err, { status: 'success', data: 'effdd4d2985361c69f078d45ba49ec9b91f049336432b644dc73fda3e92000f1', code: 200, message: '' }
  pushTx: (payToAddress, o = {}, cb) =>
    @transferPaymentHash payToAddress, o, (err, hex) =>
      request.post url: "http://#{if @settings.network == bitcore.networks.testnet then 't' else ''}btc.blockr.io/api/v1/tx/push", json: {hex: hex}, (error, response, body) =>
        cb err, body

  uotxToHash: (address, o) ->
    txid: o.tx, vout: o.n, address: address, scriptPubKey: o.script, amount: o.amount, confirmations: o.confirmations
    
module.exports = Transaction  