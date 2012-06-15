P2 = require('p2')
GalleryMain = require('/controllers/gallerymain')

class App extends P2.Controller
  constructor: ->
    super

    @gallery = new GalleryMain

    templates = ['aside', 'header']
    for tmpl in templates
      if typeof tmpl is 'string'
        html = ss.tmpl['gallery-'+tmpl].render()
      else
        html = tmpl
      @gallery.prepend html

    @append @gallery

module.exports = App
