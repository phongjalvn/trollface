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
        #DEVNOTES
        # appId: "242635384971"
        appId: "252913768155075"
        channelUrl: "/channel.html"
        status: true
        cookie: true
        xfbml: true

      FB.getLoginStatus (response) ->
        if response.status is "connected"
          ss.rpc 'user.auth', response.authResponse
        else
          P2.trigger('loader.hide')
          window.FBReady = true

      FB.Event.subscribe "auth.authResponseChange", (response) ->
        if response.status is 'connected'
          ss.rpc 'user.auth', response.authResponse
        else
          P2.trigger('loader.hide')
          window.FBReady = true

      FB.Canvas.setAutoGrow()

    ((d, s, id) ->
      js = undefined
      fjs = d.getElementsByTagName(s)[0]
      return  if d.getElementById(id)
      js = d.createElement(s)
      js.id = id
      js.src = "//connect.facebook.net/en_US/all.js"
      fjs.parentNode.insertBefore js, fjs
    ) document, "script", "facebook-jssdk"

module.exports = App
