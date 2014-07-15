/* Copyright (c) 2010, Ben Noordhuis <info@bnoordhuis.nl>
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

var buffertools = require('./buffertools');
var chai = require('chai');
var mocha = require('mocha');
var should = chai.should();
var expect = chai.expect;
var WritableBufferStream = buffertools.WritableBufferStream;

// Extend Buffer.prototype
buffertools.extend();
describe('buffertools', function() {
  var a = new Buffer('abcd'),
    b = new Buffer('abcd'),
    c = new Buffer('efgh');

  // these trigger the code paths for UnaryAction and BinaryAction
  it('should contain preconditions', function() {
    expect(function() {
      buffertools.clear({});
    }).to.
    throw ();
    expect(function() {
      buffertools.clear(new Buffer(32));
    }).not.to.
    throw ();
    expect(function() {
      buffertools.equals({}, {});
    }).to.
    throw ();
    expect(function() {
      buffertools.equals(new Buffer(32), {});
    }).to.
    throw ();
    expect(function() {
      buffertools.equals(new Buffer(32), '123123');
    }).not.to.
    throw ();
    expect(function() {
      buffertools.equals(new Buffer(32), new Buffer(48));
    }).not.to.
    throw ();
  });


  it('compare should work', function() {

    expect(a.compare(a) == 0).to.be.ok;
    expect(a.compare(c) < 0).to.be.ok;
    expect(c.compare(a) > 0).to.be.ok;

    expect(a.compare('abcd') == 0).to.be.ok;
    expect(a.compare('efgh') < 0).to.be.ok;
    expect(c.compare('abcd') > 0).to.be.ok;
  });
  it('equals should work', function() {
    expect(a.equals(b)).to.be.ok;
    expect(!a.equals(c)).to.be.ok;
    expect(a.equals('abcd')).to.be.ok;
    expect(b.equals('abcd')).to.be.ok;
    expect(!a.equals('efgh')).to.be.ok;
  });
  it('clear should work', function() {

    b = new Buffer('****');
    b.should.equal(b.clear());
    b.inspect().should.equal('<Buffer 00 00 00 00>'); // FIXME brittle test

  });
  it('fill should work', function() {
    b = new Buffer(4);
    (b).should.equal(b.fill(42));
    b.inspect().should.equal('<Buffer 2a 2a 2a 2a>');

    b = new Buffer(4);
    (b).should.equal(b.fill('*'));
    b.inspect().should.equal('<Buffer 2a 2a 2a 2a>');

    b = new Buffer(4);
    (b).should.equal(b.fill('ab'));
    b.inspect().should.equal('<Buffer 61 62 61 62>');

    b = new Buffer(4);
    (b).should.equal(b.fill('abcd1234'));
    b.inspect().should.equal('<Buffer 61 62 63 64>');
  });

  it('indexOf should work', function() {
    b = new Buffer('Hello, world!');
    (-1).should.equal(b.indexOf(new Buffer('foo')));
    (0).should.equal(b.indexOf(new Buffer('Hell')));
    (7).should.equal(b.indexOf(new Buffer('world')));
    (7).should.equal(b.indexOf(new Buffer('world!')));
    (-1).should.equal(b.indexOf('foo'));
    (0).should.equal(b.indexOf('Hell'));
    (7).should.equal(b.indexOf('world'));
    (-1).should.equal(b.indexOf(''));
    (-1).should.equal(b.indexOf('x'));
    (7).should.equal(b.indexOf('w'));
    (0).should.equal(b.indexOf('Hello, world!'));
    (-1).should.equal(b.indexOf('Hello, world!1'));
    (7).should.equal(b.indexOf('world', 7));
    (-1).should.equal(b.indexOf('world', 8));
    (7).should.equal(b.indexOf('world', -256));
    (7).should.equal(b.indexOf('world', -6));
    (-1).should.equal(b.indexOf('world', 256));
    (-1).should.equal(b.indexOf('', 256));
  });

  it('toHex/fromHex should work', function() {
    b = new Buffer("\t \r\n");
    ('09200d0a').should.equal(b.toHex());
    ('6162636420').should.equal(new Buffer('abcd ').toHex());
    (b.toString()).should.equal( new Buffer('09200d0a').fromHex().toString());

    ('').should.equal(new Buffer('').toHex());
    
    b = new Buffer(4);
    b[0] = 0x98;
    b[1] = 0x95;
    b[2] = 0x60;
    b[3] = 0x2f;
    ('9895602f').should.equal(b.toHex());

    var neg = new Buffer('ffff', 'hex');
    neg.toHex().should.equal('ffff');

  });

  it('concat should work', function() {
    buffertools.concat().equals('').should.be.ok;
    buffertools.concat('').equals('').should.be.ok;
    new Buffer('foo').concat('bar').equals('foobar').should.be.ok;
    buffertools.concat(new Buffer('foo'), 'bar', new Buffer('baz')).equals('foobarbaz').should.be.ok;
    (function() {
      buffertools.concat('foo', 123, 'baz');
    }).should.throw(Error);
    // assert that the buffer is copied, not returned as-is
    a = new Buffer('For great justice.'), b = buffertools.concat(a);
    (a.toString()).should.equal(b.toString());
    (a).should.not.equal(b);
  });

  it('reverse should work', function() {
    new Buffer('').reverse().equals('').should.be.ok;
    new Buffer('For great justice.').reverse().equals(new Buffer('.ecitsuj taerg roF')).should.be.ok;
  });

  it('edge cases should work', function() {

    var endOfHeader = new Buffer('\r\n\r\n');
    (0).should.equal(endOfHeader.indexOf(endOfHeader));
    (0).should.equal(endOfHeader.indexOf('\r\n\r\n'));

    for (var i = 0; i < 100; i++) {
      var buffer = new Buffer('9A8B3F4491734D18DEFC6D2FA96A2D3BC1020EECB811F037F977D039B4713B1984FBAB40FCB4D4833D4A31C538B76EB50F40FA672866D8F50D0A1063666721B8D8322EDEEC74B62E5F5B959393CD3FCE831CC3D1FA69D79C758853AFA3DC54D411043263596BAD1C9652970B80869DD411E82301DF93D47DCD32421A950EF3E555152E051C6943CC3CA71ED0461B37EC97C5A00EBACADAA55B9A7835F148DEF8906914617C6BD3A38E08C14735FC2EFE075CC61DFE5F2F9686AB0D0A3926604E320160FDC1A4488A323CB4308CDCA4FD9701D87CE689AF999C5C409854B268D00B063A89C2EEF6673C80A4F4D8D0A00163082EDD20A2F1861512F6FE9BB479A22A3D4ACDD2AA848254BA74613190957C7FCD106BF7441946D0E1A562DA68BC37752B1551B8855C8DA08DFE588902D44B2CAB163F3D7D7706B9CC78900D0AFD5DAE5492535A17DB17E24389F3BAA6F5A95B9F6FE955193D40932B5988BC53E49CAC81955A28B81F7B36A1EDA3B4063CBC187B0488FCD51FAE71E4FBAEE56059D847591B960921247A6B7C5C2A7A757EC62A2A2A2A2A2A2A25552591C03EF48994BD9F594A5E14672F55359EF1B38BF2976D1216C86A59847A6B7C4A5C585A0D0A2A6D9C8F8B9E999C2A836F786D577A79816F7C577A797D7E576B506B57A05B5B8C4A8D99989E8B8D9E644A6B9D9D8F9C9E4A504A6B968B93984A93984A988FA19D919C999F9A4A8B969E588C93988B9C938F9D588D8B9C9E9999989D58909C8F988D92588E0D0A3D79656E642073697A653D373035393620706172743D31207063726333323D33616230646235300D0A2E0D0A').fromHex();
      (551).should.equal(buffer.indexOf('=yend'));
    }
  });
});
