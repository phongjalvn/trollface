window.ss = require('socketstream')

P2 = require('p2')
Gallery = require('/models/gallery')
Image = require('/models/image')
Galleries = require('/controllers/galleries')
Images = require('/controllers/images')

App = require('/index')
# Wait for the DOM to finish loading
jQuery ->

  # Load app
  $ ->
    new App({el: $("body")})
