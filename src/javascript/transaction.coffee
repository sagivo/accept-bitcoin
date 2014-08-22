bitcore  = require 'bitcore'
request = require 'request'

class Transaction
  constructor: (@key, @settings) ->
  
  #options = address, includeUnconfirmed #todo
  checkBalance: (o, @cb) ->
    address = o.address || @key.address()
    includeUnconfirmed = o.includeUnconfirmed || settings.includeUnconfirmed
    @checkBalanceInterval = setInterval(@getUnspent(), @settings.checkTransactionEvery)
    getUnspent: =>
      console.log 'checking'
      if (@settings.checkTransactionMaxAttempts -= 1) < 0
        clearInterval @checkBalanceInterval
        @cb('maxAttempts'); return
      request.get "http://btc.blockr.io/api/v1/address/unspent/#{address}#{ if includeUnconfirmed then '?unconfirmed=1' else null }", (error, response, body) =>
        body = JSON.parse(body) 
        return null unless body.status == 'success' and body.data?.unspent?.length > 0
        clearInterval @checkBalanceInterval     
        @unspent = (@uotxToHash(tx) for tx in body.data.unspent when tx.confirmations >= @settings.minimumConfirmations)
        @cb null, @unspent if @cb

  #must = payToAddress | options = transferAmount, payReminderToAddress, privateKey
  transferPayment: (o = {}, cb) =>
    return cb('must have payToAddress') unless o.payToAddress
    checkBalance address: @key.address(), (err, unspent) =>
      #pay back
      transferAmount = o.transferAmount || unspent.reduce ((tot, o) -> tot + parseFloat(o.amount)),0    
      outs = address: o.payToAddress, amount: transferAmount
      options = remainderOut: address: o.payReminderToAddress || @settings.payReminderToAddress || @key.address()
      key = o.privateKey || @key.privateKey() #privateKey can be array of keys [a, b, c...]
      tx = new bitcore.TransactionBuilder(options).setUnspent(unspent).setOutputs(outs).sign(key).build()
      txHex = tx.serialize().toString('hex')
      console.log 'builder hex', txHex
      cb null, txHex

  check: (address, cb) ->
    if @unspent
      cb null 
    else
      checkBalance address: address, (err, unspent) ->
        cb(err, unspent)




  uotxToHash: (o) ->
    txid: o.tx, vout: o.n, address: @address, scriptPubKey: o.script, amount: o.amount, confirmations: o.confirmations
    
module.exports = Transaction  