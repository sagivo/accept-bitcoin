# timeago

make your dates looks like facebook/twitter.

![timeago](http://i.imgur.com/W1Zwy.png)

#install

    npm install timeago-words

or from your `package.json` file:

    "dependencies": { "timeago-words": "x" }

#usage

````javascript
var timeago = require('timeago-words');

timeago(someDate); //"x days ago"
timeago.settings; //will desplay all settings you can edit

````
make sure `someDate` is a `Date` object.

You can also use it in Express app templates:

````javascript
var app = express.createServer();

app.helpers({
  timeago: require('timeago-words')
});
````

````ejs
<div class="timeago"><%- timeago(widget.created) %></div>
````

to use custom language:
````javascript
  timeago(someDate, 'pt')
````
