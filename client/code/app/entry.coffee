window.ss = require('socketstream')

ss.server.on 'ready', ->

  jQuery ->

    P2 = require('p2')
    App = require('/index')
    new App({el: $("#main")})

