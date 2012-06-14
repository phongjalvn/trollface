P2 = require 'p2'

class Gallery extends P2.Model
  @configure 'Gallery', 'name', 'tag', 'thumb'

  @endpoint: '/galleries.json'

  @extend P2.Model.Local

  @fetch ->
    $.getJSON @endpoint, (res, status) =>
      # resp = []
      # for name, index in res
      #   resp[index] = {}
      #   ext = name.substring name.length - 4
      #   name = name.replace ext, ''
      #   lastFolderSlash = name.lastIndexOf '/'
      #   dirname = name.substring lastFolderSlash + 1

      #   resp[index].ext = ext
      #   resp[index].name = dirname
      #   resp[index].image = name

      # @refresh(resp, clear: true)
      if status is 'success' and res.length > 0
        @refresh(res, clear: true)
        @saveLocal()
      else
        P2.trigger 'gallery.lastpage'

  @default: -> new @(name: 'Lol cats', tag: 'lolcats')

module.exports = Gallery
