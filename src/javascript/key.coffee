bitcore  = require 'bitcore'
crypt  = require './encrypt'
fs = require 'fs'

class Key
  constructor: (@settings, @publicKey, @privateKeyHex) ->
    @wk = new bitcore.WalletKey(network: @settings.network) #Generate a new one (compressed public key, compressed WIF flag)
    #@wk.fromObj priv: '1637672f6705d8fb439fd52da622bad49ddb340b64182b795fc3a8d0d4667ecf'
    if arguments.length == 1 
      @wk = new bitcore.WalletKey(network: @settings.network) #Generate a new one (compressed public key, compressed WIF flag)
      @wk.generate()
      @storeKey()
    @printKey(@wk)

  wk: =>
    @wk

  address: =>
    @publicKey || @wk.storeObj().addr #return the bitcoin address

  privateKey: =>    
    @privateKeyHex || @wk.storeObj().priv

  printKey: (wk = @wk) =>
    if @publicKey and @privateKeyHex
      console.log "public: #{@publicKey} private: #{@privateKeyHex}"
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

module.exports = Key