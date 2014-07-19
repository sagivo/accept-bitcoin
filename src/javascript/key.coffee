bitcore  = require 'bitcore'
crypt  = require './encrypt'
fs = require 'fs'

class Key
  constructor: (@settings) ->
    @wk = new bitcore.WalletKey(network: @settings.network) #Generate a new one (compressed public key, compressed WIF flag)
    @wk.generate()
    #@printKey()
    @storeKey()    

  key: ->
    @wk

  address: ->
    @wk.storeObj().addr #return the bitcoin address
    
  printKey: (wk = @wk) ->
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
  
  #format: address[0]|public-hex[1]|private-hex-crypt[2]
  storeKey: (wk = @wk) ->
    wkObj = wk.storeObj()
    privateKey = if @settings.encryptPrivateKey then crypt.encrypt(bitcore.buffertools.toHex(wk.privKey.private), @settings.password) else bitcore.buffertools.toHex(wk.privKey.private)
    fs.appendFileSync(@settings.storePath,  
        wkObj.addr + "|" +
        bitcore.buffertools.toHex(wk.privKey.public) + "|" +
        privateKey + "\n"
    )

  readKeys: ->
    lines = fs.readFileSync(@settings.storePath).toString().split("\n")
    console.log lines

module.exports = Key