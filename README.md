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
Accepting bitcoins online can be complex to program and require you to install a bitcoin RPC client in order to read and write to the blockchain. This client require a lot of resources (in terms of CPU and storage).  
Most of the users are using a wallet to store their bitcoins. This wallet is a simple way to secure your public and private key. For security reasons you better save this wallet offline in a "cold storage".   
You need a way to accept bitcoins 
More about the motivation behind this project at [my blog post](http://sagivo.com/post/97125970778/bitcoin-on-node-js-do-it-yourself).

##Example
You can override the default settings on creating

Examples are provided [here](https://github.com/sagivo/accept-bitcoin/blob/master/examples.js)
```javascript
var settings = {network: 'live'}
var acceptBitcoin = require('accept-bitcoin');
ac = new acceptBitcoin('YOUR_BITCOIN_ADDRESS', settings);
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
  - **network**: choose your bitcoin RPC env. values are: `test` and `live`
nore info [here](https://github.com/bitpay/bitcore/blob/cd353ac02e76fb3294c40366d8d5dc04ce1939d7/networks.js)  
  - **password**: choose your random password to encrypt generated keys.  
  - **storePath**: path to store a file containing all the ad-hoc generated keys. Default is `./keys.json`
  - **encryptPrivateKey**: in case you want the stored keys to be encrypted (using `password`). Default is `false`.
  - **payReminderToAddress**: In case transfer amount is smaller than income and fees. 
  - **includeUnconfirmed**: include unconfirmed transactions when checking for unspent incomes. Default is `false`
  - **checkTransactionEvery**: how often to ping the network when checking for transactions. Default is 2 minutes. 
  - **checkBalanceTimeout**: timeout when checking balance of an address. Default is 120 minutes. 
  - **checkUnspentTimeout**: timeout when checking unspent transactions of an address. Default is 120 minutes. 
  - **minimumConfirmations**: minimum confirmations needed in order to trigger `` event. Default is 6 (around 1 hour to achieve 6 confirmations).
  - **txFee**: fee (in bitcoin) for transferring amount from ad hoc address to your address. Default is `0.0001`. [More here](https://en.bitcoin.it/wiki/Transaction_fees).

###Key class
This class is responsible for creating new bitcoin addresses, storing them and transferring funds between them. Some key functions are:  
`storeKey(wk)` - store your key in a local file. Can be encrypted.  
`checkBalance()`- check and notify you when an address has minimum balance.
`payTo(payToAddress, options, callback)` - transfer all balance of this address to another address.

###Encrypt class
Contains helpers to encrypt and decrypt strings. Used for storing your keys data locally.  

##Contribute
Please do. Fork it, star it, share it and add your code to the project. Help others.  
All the src code is written in [coffeescript](http://coffeescript.org) and is under `src/javascript`. There's a tool that convert it automatically to js each time you change a file and put it under `lib/javascript` folder. Simply run `cake build` for that. 

##License

MIT

