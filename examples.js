var settings = {network: 'live'}
var acceptBitcoin = require('accept-bitcoin');
var ac = new acceptBitcoin('YOUR_BITCOIN_ADDRESS', settings);
key = ac.generateAddress({alertWhenHasBalance: true});
console.log("Hello buyer! please pay to: " + key.address());
key.on('hasBalance', function(amount){
  console.log "thanks for paying me " + amount; //do stuff
  key.transferBalanceToMyAccount(function(err, d){
    if (d.status === 'success') console.log("Cool, the bitcoins are in my private account!");
  });
});
