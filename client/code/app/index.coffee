P2 = require('p2')
GalleryMain = require('/controllers/gallerymain')

class App extends P2.Controller
  constructor: ->
    super

    @gallery = new GalleryMain
    @html @gallery

module.exports = App
