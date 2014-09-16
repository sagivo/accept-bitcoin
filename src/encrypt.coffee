crypto = require 'crypto'

default_pass = 'some_password'

module.exports =
  encrypt: (text, pass = default_pass) ->
    cipher = crypto.createCipher("aes-256-cbc", pass)
    crypted = cipher.update(text, "utf8", "hex")
    crypted += cipher.final("hex")
    crypted

  decrypt: (text, pass = default_pass) ->
    decipher = crypto.createDecipher("aes-256-cbc", pass)
    dec = decipher.update(text, "hex", "utf8")
    dec += decipher.final("utf8")
    dec

  gui: ->
    Math.random().toString(36).substring(2)



#hw = encrypt("hello world")
#decrypt hw