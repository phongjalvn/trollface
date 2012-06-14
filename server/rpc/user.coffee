request = require 'superagent'
exports.actions = (req, res, ss) ->
  req.use('session')

  req.fb = (req, toGet, cb, data={})->
    return unless req.session.userId
    fb = req.session.auth.facebook
    uri = "https://graph.facebook.com/#{req.session.userId}/#{toGet}?access_token=#{fb.accessToken}"
    request.post(uri)
    .send(data)
    .set( 'Content-Type', 'application/x-www-form-urlencoded' )
    .end (response)->
      console.log response

  saveImage: (url)->
    request.post('http://api.imgur.com/2/upload.json')
    .send({key: '6a29ef3026a6c6343b65646f222b2dd2', image: url, type: url})
    .set( 'Content-Type', 'application/x-www-form-urlencoded' )
    .end (response)->
      res response.body

  makePost: (imageUrl)->
    res false unless imageUrl?
    return unless req.session.userId
    fb = req.session.auth.facebook
    # uri = "https://graph.facebook.com/#{req.session.userId}/photos?access_token=#{fb.accessToken}"
    request.post("https://graph.facebook.com/me/photos")
    .send({name:'Tao status hinh doc', url: imageUrl, access_token: fb.accessToken})
    .set( 'Content-Type', 'application/x-www-form-urlencoded' )
    .end (response)->
      res response.text
      console.log response

  getUser: ->
    res req.session.userId

  isLiked: ->
    # req.fb req, 'likes', (err, response, body)->
    #   isLiked = body.toString().indexOf(process.env.FACEBOOK_APP_ID)
    # if !isLiked?
    #   # res "Khong Like thi coi den day thoi nhe"
    #   res ""
    # else
    res ""

