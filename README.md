#Accept Bitcoin


Finally a developer-friendly tool to simply accept bitcoins in your site. 

  - Lite and fast, built on top of [bitcore](http://bitcore.io).
  - No need to install local bitcoin node RPC client.
  - No need to install any wallet client.
  - Create ad-hoc address to accept bitcoins and transfer incomes to your offline account.
  - Easy configurations.


##Get Started

Simply install via [npm](https://npmjs.org/):

```
npm install accept-bitcoin
```
##Motivation 
Accepting bitcoins online can be complex to program and require you to install a bitcoin RPC client in order to read and write to the blockchain. This client require a lot of resources (in terms of CPU and storadge).  
Most od the users are using a wallet to store their bitcoins. This wallet is a simple way to secure your public and private key. For security reasons you better save this wallet offline in a "cold storage".   
You need a way to accept bitcoins 
When you want to accept a payment from a user you need to know that the user was the 
Another issue is security - 
##Example
You can override the default settings on creating

Examples are provided [here](https://github.com/sagivo/accept-bitcoin/blob/master/examples.js)
```javascript
var settings = {payToAddress: 'YOUR_BITCOIN_ADDRESS'};
var ac = require('accept-bitcoin')(settings);
key = ac.generateAddress({alertWhenHasBalance: true});
console.log("Hello buyer! please pay to: " + key.address());
key.on('hasBalance', function(amount){
  console.log "thanks for paying me " + amount; //do stuff
  key.transferBalanceToMyAccount(function(err, d){
    if (d.status === 'success') console.log("Cool, the bitcoins are in my private account!");
  });
});
```

##Settings

You can override the default settings:  
  - **payToAddress**: Your bitcoin adress you wish to transfer incomes to. 
  - **network**: choose your bitcoin RPC env. values are: `bitcore.networks.testnet` and `bitcore.networks.livenet`
nore info [here](https://github.com/bitpay/bitcore/blob/cd353ac02e76fb3294c40366d8d5dc04ce1939d7/networks.js)  
  - **password**: choose your random password to encrypt generated keys.  
  - **storePath**: path to store a file containing all the ad-hoc generated keys. Default is `./keys.json`
  - **encryptPrivateKey**: in case you want the stored keys to be encrypted (using `password`). Default is `false`.
  - **payReminderToAddress**: In case transfer amount is smaller than income and fees. 
  - **includeUnconfirmed**: include unconfirmed transactions when checking for unspent incomes. Default is `false`
  - **checkTransactionEvery**: how often to ping the network when checking for transactions. Default is 2 minutes. 
  - **checkBalanceTimeout**: timeout when checking balance of an addresss. Default is 120 minutes. 
  - **checkUnspentTimeout**: timeout when checking unspent transactions of an addresss. Default is 120 minutes. 
  - **minimumConfirmations**: minumim confirmations needed in order to trigger `` event. Default is 6 (around 1 hour to acheave 6 confirmations).
  - **txFee**: fee (in bitcoin) for transfering amount from ad hoc address to your address. Default is `0.0001`. [More here](https://en.bitcoin.it/wiki/Transaction_fees).

###Key class
This class is responsible for creating new bitcoin adresses, storing them and transfering funds between them. Some key functions are:  
`storeKey(wk)` - store your key in a local file. Can be encrypted.  
`checkBalance()`- check and notify you when an address has minimum balance.
`payTo(payToAddress, options, callback)` - transger all balance of this address to another address.

###encrypt class
Cointains helpers to encrypt and decrypt strings. Used for storing your keys data locally.  

##Contribute
Please do. Fork it, star it, share it and add your code to the project. Help others. 

##License

MIT