http = require("http")
express = require("express")
everyauth = require("everyauth")
request = require("request")
ss = require("socketstream")


routes = (app) ->
  app.get "/", (req, res) ->
    res.serve "main"

  app.get "/auth/facebook/callback", (req, res) ->
    req.session.userId = session.userId
    req.session.save (err) ->
      res.serve "main"

  app.get "/thumb/:file", (req, res) ->
    # console.log "Proxy for: " + req.params.file
    res.redirect "http://i.imgur.com/" + req.params.file

  app.get "/full/:file", (req, res) ->
    request.get("http://i.imgur.com/" + req.params.file).pipe res

  app.get "/gallery/:file", (req, res) ->
    params = req.params.file.replace(/\:/g, '/') + ".json"
    # console.log "Proxy for gallery: " + params
    request.get("http://imgur.com/r/" + params).pipe res

  app.post "/", (req, res) ->
    res.serve "main"

ss.client.define "main",
  view  : "app.jade"
  css   : [ "libs", "app.styl" ]
  code  : [
    "libs"
    "app"
    "system"
  ]
  tmpl  : "*"

ss.client.formatters.add require("ss-coffee")
ss.client.formatters.add require("ss-jade")
ss.client.formatters.add require("ss-stylus")
ss.client.templateEngine.use require("ss-hogan")

ss.client.packAssets()  if ss.env is "production"

everyauth.facebook.callbackPath("/auth/facebook/callback")
.scope("email, user_likes, publish_stream, publish_actions")
.appId(process.env.FACEBOOK_APP_ID)
.appSecret(process.env.FACEBOOK_APP_SECR)
.findOrCreateUser((session, accessToken, accessTokenSecret, fbUserMetadata) ->
  userName = fbUserMetadata.username
  session.userId = userName
  session.save()
  true
).redirectPath "/"

app = express.createServer(
  ss.http.middleware,
  express.bodyParser(),
  express.cookieParser(),
  express.session(secret: "ILoveP2"),
  everyauth.middleware(),
  express.router(routes)
)
port = process.env.PORT or 3000
server = app.listen(port)
ss.start server