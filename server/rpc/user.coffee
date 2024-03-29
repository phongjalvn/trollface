request = require 'request'
FB = require 'fb'
exports.actions = (req, res, ss) ->
  req.use('session')

  auth: (authdata)->
    return unless authdata.accessToken
    req.session.fb = authdata
    FB.options({accessToken: authdata.accessToken})
    FB.api '/me', (response)->
      if response?.error then return
      req.session.setUserId response.username
      ss.publish.user(req.session.userId, 'auth', req.session.userId)

  checkLike: ->
    FB.api '/me/likes', (response)->
      console.log response
      if response?.error then return
      req.session.setUserId response.username
      ss.publish.user(req.session.userId, 'auth', req.session.userId)

  makePost: (imgUrl, message)->
    FB.options({accessToken: req.session.fb.accessToken})
    FB.api "/#{req.session.userId}/photos","post", {name: "#{message} - Tạo status độc tại https://apps.facebook.com/fb-jstest/", url: "#{imgUrl}"}, (response)->
      if response?.error then return
      ss.publish.user(req.session.userId, 'postSuccess', response)

