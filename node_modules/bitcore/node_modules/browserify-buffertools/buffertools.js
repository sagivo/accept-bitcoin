'use strict';


// requires node 3.1
var events = require('events');
var util = require('util');

var buffertools = {};
module.exports.Buffer = Buffer;


var is_buffer = function(x) {
  return x instanceof Buffer || x instanceof Uint8Array;
};

var unaryAction = function(f) {
  return function() {
    var target = this;
    if (is_buffer(target)) {} else if (is_buffer(arguments[0])) {
      target = arguments[0];
      Array.prototype.shift.apply(arguments);
    } else {
      throw new Error('Argument should be a buffer object.');
    }
    return f.apply(target, arguments);
  };
};

var binaryAction = function(f) {
  return function() {
    var target = this;

    // first argument
    if (is_buffer(target)) {} else if (is_buffer(arguments[0])) {
      target = arguments[0];
      Array.prototype.shift.apply(arguments);
    } else {
      throw Error('Argument should be a buffer object.');
    }

    // second argument
    var next = arguments[0];
    if (typeof next == 'string' || next instanceof String || is_buffer(next)) {
      return f.apply(target, arguments);
    }
    throw new Error('Second argument must be a string or a buffer.');
  };
};

buffertools.clear = unaryAction(function() {
  for (var i = 0; i < this.length; i++) {
    this[i] = 0;
  }
  return this;
});

buffertools.fill = unaryAction(function(data) {
  var step = typeof data.length === 'undefined' ? 1 : data.length;
  for (var i = 0; i < this.length; i += step) {
    for (var k = 0; k < step; k++) {
      this[i + k] = typeof data.length === 'undefined' ? data :
        (typeof data[k] === 'string' ? data[k].charCodeAt(0) : data[k]);
    }
  }
  return this;
});

buffertools.indexOf = unaryAction(function(data, startFrom) {
  startFrom = startFrom || 0;
  if (data.length === 0) return -1;
  for (var i = startFrom; i < this.length - data.length + 1; i += 1) {
    var found = true;
    for (var j = 0; j < data.length; j++) {
      var a = this[i + j];
      var b = data[j];
      if (typeof b === 'string') b = b.charCodeAt(0);
      if (a !== b) {
        found = false;
        break;
      }
    }
    if (found) return i;
  }
  return -1;
});

buffertools.equals = binaryAction(function(data) {
  return buffertools.compare(this, data) === 0;
});

buffertools.compare = binaryAction(function(data) {
  var buffer = this;
  var l1 = buffer.length;
  var l2 = data.length;
  if (l1 !== l2) {
    return l1 > l2 ? 1 : -1;
  }
  for (var i = 0; i < l1; i++) {
    var a = buffer[i];
    var b = data[i];
    if (typeof b === 'string') b = b.charCodeAt(0);
    if (a === b) continue;
    return a > b ? 1 : -1;
  }
  return 0;
});
buffertools.concat = function() {
  var len = 0;
  for (var i = 0; i < arguments.length; i++) {
    if (arguments[i].length === undefined) throw Error('all arguments must be strings or Buffers');
    len += arguments[i].length;
  }
  var ret = new Buffer(len);
  var k = 0;
  for (var i = 0; i < arguments.length; i++) {
    for (var j = 0; j < arguments[i].length; j++) {
      ret[k++] = typeof arguments[i][j] === 'string' ?
        arguments[i][j].charCodeAt(0) : arguments[i][j];
    }
  }
  return ret;
};
buffertools.reverse = unaryAction(function() {
  var ret = new Buffer(this.length);
  for (var i = 0; i < this.length; i++) {
    ret[i] = this[this.length - i - 1];
  }
  return ret;
});

buffertools.toHex = unaryAction(function() {
  var s = '';
  for (var i = 0; i < this.length; i++) {
    var h = this[i].toString(16);
    if (h.length == 1) h = '0' + h;
    if (h.length > 2) h = h.substring(1,3);
    s += h;
  }
  return s;
});
buffertools.fromHex = unaryAction(function() {
  var l = this.length;
  if (l % 2 !== 0) throw new Error('Invalid hex string length');
  var ret = new Buffer(l / 2);
  for (var i = 0; i < ret.length; i++) {
    var c1 = String.fromCharCode(this[2 * i]);
    var c2 = String.fromCharCode(this[2 * i + 1]);
    ret[i] = parseInt(c1 + c2, 16);
  }
  return ret;
});

exports.extend = function() {
  var receivers;
  if (arguments.length > 0) {
    receivers = Array.prototype.slice.call(arguments);
  } else if (typeof Uint8Array === 'function') {
    receivers = [Buffer.prototype, Uint8Array.prototype];
  } else {
    receivers = [Buffer.prototype];
  }
  for (var i = 0, n = receivers.length; i < n; i += 1) {
    var receiver = receivers[i];
    for (var key in buffertools) {
      receiver[key] = buffertools[key];
    }
    if (receiver !== exports) {
      receiver.concat = function() {
        var args = [this].concat(Array.prototype.slice.call(arguments));
        return buffertools.concat.apply(buffertools, args);
      };
    }
  }
};
exports.extend(exports);

//
// WritableBufferStream
//
// - never emits 'error'
// - never emits 'drain'
//
function WritableBufferStream() {
  this.writable = true;
  this.buffer = null;
}

util.inherits(WritableBufferStream, events.EventEmitter);

WritableBufferStream.prototype._append = function(buffer, encoding) {
  if (!this.writable) {
    throw new Error('Stream is not writable.');
  }

  if (Buffer.isBuffer(buffer)) {
    // no action required
  } else if (typeof buffer == 'string') {
    // TODO optimize
    buffer = new Buffer(buffer, encoding || 'utf8');
  } else {
    throw new Error('Argument should be either a buffer or a string.');
  }

  // FIXME optimize!
  if (this.buffer) {
    this.buffer = buffertools.concat(this.buffer, buffer);
  } else {
    this.buffer = new Buffer(buffer.length);
    buffer.copy(this.buffer);
  }
};

WritableBufferStream.prototype.write = function(buffer, encoding) {
  this._append(buffer, encoding);

  // signal that it's safe to immediately write again
  return true;
};

WritableBufferStream.prototype.end = function(buffer, encoding) {
  if (buffer) {
    this._append(buffer, encoding);
  }

  this.emit('close');

  this.writable = false;
};

WritableBufferStream.prototype.getBuffer = function() {
  if (this.buffer) {
    return this.buffer;
  }
  return new Buffer(0);
};

WritableBufferStream.prototype.toString = function() {
  return this.getBuffer().toString();
};

exports.WritableBufferStream = WritableBufferStream;
