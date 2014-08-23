bitcore  = require 'bitcore'
crypt  = require './encrypt'
fs = require 'fs'
request = require 'request'
ee = require('events').EventEmitter

class Key
  constructor: (@settings, @publicKey, @privateKeyWif) ->
    ee.call(this)
    @wk = new bitcore.WalletKey(network: @settings.network) #Generate a new one (compressed public key, compressed WIF flag)
    @wk.fromObj priv: @privateKeyWif if @privateKeyWif
    if arguments.length <= 1
      @wk.generate()
      @storeKey()
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
    checkBalanceInterval = setInterval( =>
        console.log "checking balance for #{@address()}"
        request.get "http://#{if @settings.network == bitcore.networks.testnet then 't' else ''}btc.blockr.io/api/v1/address/info/#{@address()}#{ if @settings.includeUnconfirmed then '?unconfirmed=1' else '' }", (error, response, body) =>
          body = JSON.parse(body) 
          if body.status == 'success' and body.data?.balance > 0
            clearInterval checkBalanceInterval
            this.emit('haveBalance', null, body.data?.balance)
      , @settings.checkTransactionEvery)
    

Key.prototype.__proto__ = ee.prototype
module.exports = Key