Spine = require('spine')

class Gallery extends Spine.Model
  @configure 'Gallery', 'ext', 'name', 'image'

  @extend Spine.Model.Local

  @endpoint: 'http://localhost/direx/index.php'

  @fetch ->
    $.getJSON @endpoint, (res) =>
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
  @default: -> new @(name: 'Lol cats', tag: 'lolcats')

module.exports = Gallery
