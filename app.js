// Generated by CoffeeScript 1.3.3
(function() {
  var app, everyauth, express, http, port, request, routes, server, ss;

  http = require("http");

  express = require("express");

  everyauth = require("everyauth");

  request = require("request");

  ss = require("socketstream");

  ss.client.define("main", {
    view: "app.jade",
    css: ["libs", "app.styl"],
    code: ["libs", "app", "system"],
    tmpl: "*"
  });

  routes = function(app) {
    app.get("/", function(req, res) {
      return res.serve("main");
    });
    app.get("/auth/facebook/callback", function(req, res) {
      req.session.userId = session.userId;
      return req.session.save(function(err) {
        return res.serve("main");
      });
    });
    app.get("/thumb/:file", function(req, res) {
      return res.redirect("http://i.imgur.com/" + req.params.file);
    });
    app.get("/full/:file", function(req, res) {
      return request.get("http://i.imgur.com/" + req.params.file).pipe(res);
    });
    app.get("/gallery/:file", function(req, res) {
      var params;
      params = req.params.file.replace(/\:/g, '/') + ".json";
      return request.get("http://imgur.com/r/" + params).pipe(res);
    });
    return app.post("/", function(req, res) {
      return res.serve("main");
    });
  };

  ss.client.formatters.add(require("ss-coffee"));

  ss.client.formatters.add(require("ss-jade"));

  ss.client.formatters.add(require("ss-stylus"));

  ss.client.templateEngine.use(require("ss-hogan"));

  everyauth.facebook.callbackPath("/auth/facebook/callback").scope("email, user_likes, publish_stream, publish_actions").appId('242635384971').appSecret('2236411e218eadfe32f59c621125a560').findOrCreateUser(function(session, accessToken, accessTokenSecret, fbUserMetadata) {
    var userName;
    userName = fbUserMetadata.username;
    session.userId = userName;
    session.save();
    return true;
  }).redirectPath("/");

  app = express.createServer(ss.http.middleware, ss.http.connect.bodyParser(), everyauth.middleware(), express.router(routes));

  port = process.env.PORT || 3000;

  server = app.listen(port);

  ss.start(server);

}).call(this);
