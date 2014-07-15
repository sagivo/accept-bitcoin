http = require 'http'
bitcore  = require 'bitcore'

module.exports = (address, o = {}) ->
  return 'must have address' unless address
  console.log 'hello ' + address

  run()

module.exports.settings =
  allowFuture: false

inWords = (distanceMillis, ln = 'en') ->
  settings = module.exports.settings


run = ->
  # replace '../bitcore' with 'bitcore' if you use this code elsewhere.
  print = (wk) ->
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
    console.log "address is valid? #{wkObj.addr.isValid()}"
    return
  WalletKey = bitcore.WalletKey
  opts = network: bitcore.networks.livenet #testnet
  #Generate a new one (compressed public key, compressed WIF flag)
  wk = new WalletKey(opts)
  wk.generate()
  print wk    
  return