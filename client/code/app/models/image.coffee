Spine = require('spine')

class Image extends Spine.Model
  @configure 'Image', 'ext', 'name', 'image'

  @extend Spine.Model.Local

  @endpoint: 'http://localhost/direx/index.php?callback=?&dir='

  @fetch ->
    args = [].splice.call(arguments,0).join('/')
    if args.length is 0 then return
    $.getJSON @endpoint + args, (res) =>
      resp = []
      for name, index in res
        resp[index] = {}
        ext = name.substring name.length - 4
        name = name.replace ext, ''
        lastFolderSlash = name.lastIndexOf '/'
        dirname = name.substring lastFolderSlash + 1

        resp[index].ext = ext
        resp[index].name = dirname
        resp[index].image = name

      @refresh(resp, clear: true)
      @saveLocal()

  # @extend Spine.Model.Local

  # @endpoint: 'http://phongjalvn.kodingen.com/hello.php?callback=?&url='+escape('http://imgur.com/r/')

  # @fetch: ->
  #   $.getJSON @endpoint + args + '.json', (res) =>
  #     resp = res.contents.gallery
  #     @refresh(resp, clear: arguments.length > 1)
  #     @saveLocal()

module.exports = Image
