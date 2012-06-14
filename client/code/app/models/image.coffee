P2 = require 'p2'

class Image extends P2.Model
  @configure 'Image', 'hash', 'title', 'ext'

  @endpoint: '/gallery/'

  @extend P2.Model.Local

  @fetch: (tag, page...)->
    return unless tag? and !@lastPage
    pages = page?.join(':') or ''
    $.getJSON @endpoint + tag + pages, (res, status) =>
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
      if status is 'success' and res.gallery.length > 0
        @refresh(res.gallery, clear: true)
        @saveLocal()
      else
        @lastPage = true
        P2.trigger 'gallery.lastpage'

  # @extend Spine.Model.Local

  # @endpoint: 'http://phongjalvn.kodingen.com/hello.php?callback=?&url='+escape('http://imgur.com/r/')

  # @fetch: ->
  #   $.getJSON @endpoint + args + '.json', (res) =>
  #     resp = res.contents.gallery
  #     @refresh(resp, clear: arguments.length > 1)
  #     @saveLocal()

module.exports = Image
