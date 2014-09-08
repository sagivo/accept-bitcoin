Ac = require('./lib/javascript/index')
ac = new Ac('sagiv ofek')

key = ac.generateAddress alertWhenHasBalance: true, (key) ->
  console.log "we have a key!",key
console.log "please pay to: " + key.address()
key.on 'hasBalance', (amount) ->
  console.log "thanks for paying me " + amount
  key.transferBalanceToMyAccount fee: 0, (err, d) ->
    console.log "DONE", d

#key.transferPaymentHash 'muVxU1ZH4yLbV9FrjD3WXv5bzD2JChSkhw', (err, d) ->
#  console.log "DONE", d