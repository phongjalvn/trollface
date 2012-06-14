window.ss = require('socketstream')

P2 = require('p2')
App = require('/index')
# Wait for the DOM to finish loading
jQuery ->

  # Load app
  $ ->
    new App({el: $("body")})
