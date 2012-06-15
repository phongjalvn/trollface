http = require("http")
express = require("express")
request = require("request")
FB = require('fb')
ss = require("socketstream")

ss.client.define "main",
  view  : "app.jade"
  css   : [ "libs", "app.styl" ]
  code  : [
    "libs"
    "app"
    "system"
  ]
  tmpl  : "*"

FB.setAccessToken('access_token')

app = express.createServer(
  ss.http.middleware,
  # express.logger(),
  express.bodyParser(),
  express.cookieParser(),
  # express.router(routes)
  express.session(secret: "ILoveP2")
)

app.all "/", (req, res, next) ->
  res.header "Access-Control-Allow-Origin", "*"
  res.header "Access-Control-Allow-Headers", "X-Requested-With"
  next()

app.get "/", (req, res) ->
  res.serve "main"

app.post "/", (req, res) ->
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

ss.client.formatters.add require("ss-coffee")
ss.client.formatters.add require("ss-jade")
ss.client.formatters.add require("ss-stylus")
ss.client.templateEngine.use require("ss-hogan")

ss.client.packAssets() if ss.env is "production"

ss.ws.transport.use(require('ss-sockjs'))
# ss.ws.transport.use(require('ss-sockjs'),{
#   client: {
#     debug: true
#   }, server: {
#     log: (severity, message)->
#       console.log('Custom logger >>>', severity, message);
#   }
# })

app.stack = app.stack.concat(ss.http.middleware.stack)
ss.publish.transport.use('redis', {host: 'tetra.redistogo.com', port: 9461, user:'nodejitsu', pass: 'cd55e4fc7ee4a4b93386ec5d89ec8346', db: 1})
ss.session.store.use('redis', {host: 'tetra.redistogo.com', port: 9461, user:'nodejitsu', pass: 'cd55e4fc7ee4a4b93386ec5d89ec8346', db: 1})
port = process.env.PORT or 3000
server = app.listen(port)
ss.start server
