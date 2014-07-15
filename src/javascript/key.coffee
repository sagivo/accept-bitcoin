bitcore  = require 'bitcore'

class Key
  constructor: (o = {}) ->

  createKeyPair: (o = {}) ->
    @wk = new bitcore.WalletKey(o) #Generate a new one (compressed public key, compressed WIF flag)
    @wk.generate()
    @printKey()
    
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

module.exports = Key