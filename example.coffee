Ac = require('./lib/javascript/index')
ac = new Ac('sagiv ofek')
key = ac.generateKey()
console.log 'aaa', key.address()
#console.log ac.generateKey()
ac.on 'foo', (d) ->
  console.log 'result foo:', d
#ac.paymentRequest a: 'bb', (err, d) ->
#  console.log d

