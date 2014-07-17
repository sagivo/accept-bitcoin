bitcore  = require 'bitcore'
fs = require 'fs'

class Key
  constructor: (o = {}) ->
    @storePath = o.storePath || './keys.json'
    @wk = new bitcore.WalletKey(o) #Generate a new one (compressed public key, compressed WIF flag)
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
  
  storeKey: (wk = @wk) ->
    console.log 'storePath', @storePath
    fs.appendFileSync @storePath, '223asda|affsd33dsf|dsflklcaf' + "\n"

  readKeys: ->
    lines = fs.readFileSync(@storePath).toString().split("\n")
    console.log lines

module.exports = Key