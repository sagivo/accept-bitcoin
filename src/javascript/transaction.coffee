bitcore  = require 'bitcore'
request = require 'request'

class Transaction
  constructor: (@key, @settings) ->
  
  checkBalance: (@cb) ->
    @address = '14nsgXjL7xCEXFf8UkGCm9KnSTTFBDKqcn' #TODO: change to key.address()
    @checkBalanceInterval = setInterval(@getUnspent(), @settings.checkTransactionEvery)

  getUnspent: =>
    console.log 'checking'
    if (@settings.checkTransactionMaxAttempts -= 1) < 0
      clearInterval @checkBalanceInterval
      @cb('maxAttempts'); return
    request.get "http://btc.blockr.io/api/v1/address/unspent/#{@address}", (error, response, body) =>        
      body = JSON.parse(body) 
      return null unless body.status == 'success' and body.data?.unspent?.length > 0
      clearInterval @checkBalanceInterval     
      @unspent = (@uotxToHash(tx) for tx in body.data.unspent when tx.confirmations >= @settings.minimumConfirmations)
      @cb null, @unspent if @cb

  transferPayment: (o = {}, cb) =>
    #pay back
    tot_amount = @unspent.reduce ((tot, o) -> tot + parseFloat(o.amount)),0
    console.log "tot_amount", tot_amount
    outs = address: @settings.payToAddress, amount: tot_amount
    opts = remainderOut: address: @settings.payReminderToAddress 
    tx = new bitcore.TransactionBuilder(opts).setUnspent(@unspent).setOutputs(outs).sign(@key.privateKey()).build()
    txHex = tx.serialize().toString('hex')
    cb null, txHex



  uotxToHash: (o) ->
    txid: o.tx, vout: o.n, address: @address, scriptPubKey: o.script, amount: o.amount, confirmations: o.confirmations
    
module.exports = Transaction  