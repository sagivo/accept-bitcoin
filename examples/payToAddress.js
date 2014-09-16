var settings = {network: 'test'}
var acceptBitcoin = require('accept-bitcoin');
var ac = new acceptBitcoin('YOUR_BITCOIN_ADDRESS', settings);
existingKey = ac.generateAddress(settings, 'Your Public key', 'your private key in WIF format');

existingKey.payTo('address to pay to', {amount: 0.1, fee: 0.0001}, function(err, response){
  if (response.status == 'success')
    console.log("WOHOO! DONE");
});