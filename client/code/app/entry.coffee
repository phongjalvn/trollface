window.ss = require('socketstream')

# require('/loadercontrol')

require('spine')
require('ajax')
require('local')
require('manager')
require('relation')
require('route')
require('list')
App = require('/index')

# Wait for the DOM to finish loading
jQuery ->

  # Load app
  $ ->
    new App({el: $("body")})
    $("img").lazyload()
