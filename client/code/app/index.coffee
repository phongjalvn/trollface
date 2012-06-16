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

    window.fbAsyncInit = =>
      FB.init
        appId: "252913768155075"
        channelUrl: "/channel.html"
        status: true
        cookie: true
        xfbml: true

      FB.Event.subscribe "auth.login", (response) ->
        console.log response
        if response.status is 'connected'
          ss.rpc 'user.auth', response.authResponse, ()->
            $('.loader').transition
              opacity: 1
              top: 0

      FB.Canvas.setAutoGrow()

      @getLoginStatus()

    ((d, s, id) ->
      js = undefined
      fjs = d.getElementsByTagName(s)[0]
      return  if d.getElementById(id)
      js = d.createElement(s)
      js.id = id
      js.src = "//connect.facebook.net/en_US/all.js"
      fjs.parentNode.insertBefore js, fjs
    ) document, "script", "facebook-jssdk"

  getLoginStatus: =>
    FB.getLoginStatus (response)=>
      if response.status is 'connected'
        ss.rpc 'user.auth', response.authResponse
      else
        setTimeout ->
          @getLoginStatus()
        , 1000

module.exports = App
