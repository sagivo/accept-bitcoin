var lazy = require("lazy"), fs = require("fs"), acceptBitcoin = require('accept-bitcoin');

var settings = {
  network: 'test', 
  storePath: './myKeyPath/myfile.txt',
  encryptPrivateKey: true
}

var ac = new acceptBitcoin('YOUR_BITCOIN_ADDRESS', settings);

key = ac.generateAddress(); 
//public and private keys (encrypted) were added to myfile.txt
console.log("Hello buyer! please pay to: " + key.address());
//read the file
new lazy(fs.createReadStream(settings.storePath)).lines.forEach(function(line){
  //keys are stored in each line in format of "publicKey|privateKey"
  line = line.toString().split('|');  
  publicKey = line[0];
  privateKey = ac.decrypt(line[1]);  
  console.log("public key: " + publicKey + " private key: " + privateKey);
});
