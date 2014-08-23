Ac = require('./lib/javascript/index')
ac = new Ac('sagiv ofek')
key = ac.generateAddress()

key.on 'haveBalance', (err, d) ->
  console.log "have balance", d

key.checkBalance()
#console.log ac.generateKey()
ac.on 'foo', (d) ->
  console.log 'result foo:', d
#ac.paymentRequest a: 'bb', (err, d) ->
#  console.log d

