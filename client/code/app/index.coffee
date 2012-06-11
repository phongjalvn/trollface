Spine = require('spine')
GalleryMain = require('/controllers/gallerymain')

class App extends Spine.Controller
  constructor: ->
    super

    @gallery = new GalleryMain
    @html @gallery

module.exports = App
