Spine = require('spine')

class Image extends Spine.Model
  @configure 'Image', 'title', 'hash', 'ext', 'width', 'height'

  @extend Spine.Model.Local

  @endpoint: 'http://phongjalvn.kodingen.com/hello.php?callback=?&url='+escape('http://imgur.com/r/')

  @fetch: ->
    args = escape([].splice.call(arguments,0).join('/'))
    if args.length is 0 then return
    $.getJSON @endpoint + args + '.json', (res) =>
      resp = res.contents.gallery
      @refresh(resp, clear: arguments.length > 1)
      @saveLocal()

module.exports = Image
