Spine = require('spine')

class Gallery extends Spine.Model
  @configure 'Gallery', 'name', 'tag', 'thumb', 'width', 'height'

  @extend Spine.Model.Local

  @endpoint: '/galleries.php'

  @fetch ->
    $.getJSON @endpoint, (res) =>
      @refresh(res, clear: true)
      @saveLocal()
  @default: -> new @(name: 'Lol cats', tag: 'lolcats')

module.exports = Gallery
