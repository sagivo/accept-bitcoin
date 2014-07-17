bitcore  = require 'bitcore'
crypt  = require './encrypt'
fs = require 'fs'

class Key
  constructor: (@settings) ->
    @wk = new bitcore.WalletKey(network: @settings.network) #Generate a new one (compressed public key, compressed WIF flag)
    @wk.generate()
    @printKey()
    @storeKey()

  key: ->
    @wk
    
  printKey: (wk = @wk) ->
    console.log 'xxxxwk'
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
  
  #format: private (encryot)|public|address
  storeKey: (wk = @wk) ->
    fs.appendFileSync @settings.storePath, '223asda|affsd33dsf|dsflklcaf' + "\n"

  readKeys: ->
    lines = fs.readFileSync(@settings.storePath).toString().split("\n")
    console.log lines

module.exports = Key