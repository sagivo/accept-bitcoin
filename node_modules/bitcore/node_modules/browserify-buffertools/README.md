# browserify-buffertools #

A JavaScript implementation of [node-buffertools](https://github.com/bnoordhuis/node-buffertools) for use in the browser via [browserify](http://browserify.org/).

## Usage and limitations
API functionality should be identical to that of [node-buffertools](https://github.com/bnoordhuis/node-buffertools). Our test cases are very inspired in the original node test cases. However, a few things are missing: (feel free to contribute Pull Requests)
* The WritableBufferStream class is available but totally untested.

## Running tests

To run node tests run:
```
mocha
```

To run browser tests, run:
```
grunt browserify
```
And open test.html in your browser.

