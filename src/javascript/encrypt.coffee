crypto = require 'crypto'

module.exports =
  encrypt: (text) ->
    cipher = crypto.createCipher("aes-256-cbc", "theBestSite!")
    crypted = cipher.update(text, "utf8", "hex")
    crypted += cipher.final("hex")
    crypted

  decrypt: (text) ->
    decipher = crypto.createDecipher("aes-256-cbc", "theBestSite!")
    dec = decipher.update(text, "hex", "utf8")
    dec += decipher.final("utf8")
    dec

  gui: ->
    Math.random().toString(36).substring(2)



#hw = encrypt("hello world")
#decrypt hw