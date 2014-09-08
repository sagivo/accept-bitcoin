bitcore  = require 'bitcore'
crypt  = require './encrypt'
fs = require 'fs'
request = require 'request'
ee = require('events').EventEmitter

class Key
  #settings, callback(key)
  constructor: (@settings, @publicKey, @privateKeyWif) ->
    ee.call(this)
    cb = @publicKey if @publicKey instanceof Function
    @wk = new bitcore.WalletKey(network: @settings.network) #Generate a new one (compressed public key, compressed WIF flag)
    @wk.fromObj priv: @privateKeyWif if @privateKeyWif
    if arguments.length <= 1 or cb
      @wk.generate()
      if cb
        cb @wk
      else @storeKey()
    @printKey(@wk)

  wk: =>
    @wk

  address: =>
    @publicKey || @wk.storeObj().addr #return the bitcoin address

  privateKey: =>    
    @privateKeyWif || @wk.storeObj().priv

  printKey: (wk = @wk) =>
    if @publicKey and @privateKeyWif
      console.log "public: #{@publicKey} private: #{@privateKeyWif}"
    else
      console.log "## Network: " + wk.network.name
      console.log "*** Hex Representation"
      console.log "Private: " + bitcore.buffertools.toHex(wk.privKey.private)
      console.log "Public : " + bitcore.buffertools.toHex(wk.privKey.public)
      console.log "Public Compressed : " + ((if wk.privKey.compressed then "Yes" else "No"))
      wkObj = wk.storeObj()
      console.log "*** WalletKey Store Object"
      console.log "Private: " + wkObj.priv
      console.log "Public : " + wkObj.pub
      console.log "Addr   : " + wkObj.addr
  
  #format: address[0]|private key in WalletKey Store Object format[1]
  storeKey: (wk = @wk) =>
    wkObj = wk.storeObj()
    privateKey = if @settings.encryptPrivateKey then crypt.encrypt(@privateKey(), @settings.password) else @privateKey()
    fs.appendFileSync(@settings.storePath,  
        @address() + "|" +
        privateKey + "\n"
    )

  readKeys: =>
    lines = fs.readFileSync(@settings.storePath).toString().split("\n")
    console.log lines

  checkBalance: =>
    checkBalanceTimeout = setTimeout ->
      this.emit('checkBalanceTimeout')
    , @settings.checkBalanceTimeout

    checkBalanceInterval = setInterval( =>
        console.log "checking balance for #{@address()}"
        request.get "http://#{if @settings.network == bitcore.networks.testnet then 't' else ''}btc.blockr.io/api/v1/address/info/#{@address()}", (error, response, body) =>
          body = JSON.parse(body) 
          if body.status == 'success' and body.data?.balance > 0            
            clearInterval checkBalanceInterval; clearTimeout checkBalanceTimeout
            this.emit('hasBalance', body.data?.balance)
      , @settings.checkTransactionEvery)

  checkUnspent: (cb) =>
    checkUnspentTimeout = setTimeout ->
      clearInterval(checkUnspentInterval); cb('checkUnspentTimeout') if cb
    , @settings.checkUnspentTimeout

    checkUnspentInterval = setInterval( =>
        console.log "checking unspents for #{@address()}"
        request.get "http://#{if @settings.network == bitcore.networks.testnet then 't' else ''}btc.blockr.io/api/v1/address/unspent/#{@address()}#{ if @settings.minimumConfirmations == 0 then '?unconfirmed=1' else '' }", (error, response, body) =>
          body = JSON.parse(body) 
          if body.status == 'success' and body.data?.unspent?.length > 0
            unspent = (@uotxToHash(tx) for tx in body.data.unspent when tx.confirmations >= @settings.minimumConfirmations)
            console.log unspent.reduce ((tot, o) -> tot + parseFloat(o.amount)),0
            if unspent.length > 0 #unspents bigger than minimum confirmations
              clearInterval checkUnspentInterval; clearTimeout checkUnspentTimeout
              cb(null, unspent)
              this.emit('haveUnspent', unspent)
      , @settings.checkTransactionEvery) 
  
  #must = payToAddress | options = amount, payReminderToAddress, txFee
  transferPaymentHash: (payToAddress, o = {}, cb) =>
    return unless payToAddress
    #normalize
    if arguments.length == 2 and o instanceof Function
      cb = o; o = {};    
    @checkUnspent (err, unspent) =>
      cb err if err
      fee = o.txFee || @settings.txFee
      amount = o.amount || unspent.reduce ((tot, o) -> tot + parseFloat(o.amount)),0 - fee
      outs = [{address: payToAddress, amount: amount}]
      options = remainderOut: address: o.payReminderToAddress || @settings.payReminderToAddress || @address()#, fee: fee
      tx = new bitcore.TransactionBuilder(options).setUnspent(unspent).setOutputs(outs).sign([@privateKey()]).build()
      console.log "Paying #{amount} from #{@address()} to #{payToAddress}"
      txHex = tx.serialize().toString('hex')
      cb null, txHex

  #must = payToAddress | options = amount, payReminderToAddress, txFee
  #response: err, { status: 'success', data: 'effdd4d2985361c69f078d45ba49ec9b91f049336432b644dc73fda3e92000f1', code: 200, message: '' }
  payTo: (payToAddress, o = {}, cb = ->) =>
    return unless payToAddress
    #normalize
    if arguments.length == 2 and o instanceof Function
      cb = o; o = {};
    @transferPaymentHash payToAddress, o, (err, hex) =>
      cb err if err
      request.post url: "http://#{if @settings.network == bitcore.networks.testnet then 't' else ''}btc.blockr.io/api/v1/tx/push", json: {hex: hex}, (error, response, body) =>
        cb err, body

  #response: err, { status: 'success', data: 'effdd4d2985361c69f078d45ba49ec9b91f049336432b644dc73fda3e92000f1', code: 200, message: '' }
  transferBalanceToMyAccount: (o, cb) =>  
    @payTo @settings.payToAddress, o, cb

  uotxToHash: (o) ->
    txid: o.tx, vout: o.n, address: @address(), scriptPubKey: o.script, amount: o.amount, confirmations: o.confirmations

Key.prototype.__proto__ = ee.prototype
module.exports = Key