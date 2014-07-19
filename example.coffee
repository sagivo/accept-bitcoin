Ac = require('./lib/javascript/index')
ac = new Ac('aa')
key = ac.paymentRequest a: 'bb', (err, d) ->
  console.log d
