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

##Example
You can override the default settings on creating

Examples are provided [here](examples.md)
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
  - **checkTransactionEvery**:

Markdown is a lightweight markup language based on the formatting conventions that people naturally use in email.  As [John Gruber] writes on the [Markdown site] [1]:

> The overriding design goal for Markdown's
> formatting syntax is to make it as readable 
> as possible. The idea is that a
> Markdown-formatted document should be
> publishable as-is, as plain text, without
> looking like it's been marked up with tags
> or formatting instructions.

This text you see here is *actually* written in Markdown! To get a feel for Markdown's syntax, type some text into the left window and watch the results in the right.  

Version
----

2.0

Tech
-----------

Dillinger uses a number of open source projects to work properly:

* [Ace Editor] - awesome web-based text editor
* [Marked] - a super fast port of Markdown to JavaScript
* [Twitter Bootstrap] - great UI boilerplate for modern web apps
* [node.js] - evented I/O for the backend
* [Express] - fast node.js network app framework [@tjholowaychuk]
* [keymaster.js] - awesome keyboard handler lib by [@thomasfuchs]
* [jQuery] - duh 

Installation
--------------

```sh
git clone [git-repo-url] dillinger
cd dillinger
npm i -d
mkdir -p public/files/{md,html,pdf}
```

##### Configure Plugins. Instructions in following README.md files

* plugins/dropbox/README.md
* plugins/github/README.md
* plugins/googledrive/README.md

```sh
node app
```


License
----

MIT


**Free Software, Hell Yeah!**

[john gruber]:http://daringfireball.net/
[@thomasfuchs]:http://twitter.com/thomasfuchs
[1]:http://daringfireball.net/projects/markdown/
[marked]:https://github.com/chjj/marked
[Ace Editor]:http://ace.ajax.org
[node.js]:http://nodejs.org
[Twitter Bootstrap]:http://twitter.github.com/bootstrap/
[keymaster.js]:https://github.com/madrobby/keymaster
[jQuery]:http://jquery.com
[@tjholowaychuk]:http://twitter.com/tjholowaychuk
[express]:http://expressjs.com
