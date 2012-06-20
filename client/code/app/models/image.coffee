P2 = require 'p2'

class Image extends P2.Model
  @configure 'Image', 'hash', 'title', 'ext'

  @endpoint: '/gallery/'

  @extend P2.Model.Local

  @fetch: (tag, page...)->
    return unless tag? and !@lastPage
    pages = page?.join(':') or ''
    $.getJSON @endpoint + tag + pages, (res, status) =>
      if status is 'success' and res.album.images.length > 0
        resp = []
        for imagedata, index in res.album.images
          image = imagedata.image
          sep = image.type.lastIndexOf('/') + 1
          image.ext = "."+image.type.substring(sep)
          resp.push(image)
        @refresh(resp, clear: true)
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
