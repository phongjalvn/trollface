// My SocketStream app

var http = require('http')
  , express = require('express')
  , ss = require('socketstream');

// Define a single-page client
ss.client.define('main', {
  view: 'app.jade',
  css:  ['libs', 'app.styl'],
  code: ['libs', 'app', 'system'],
  tmpl: '*'
});

// Code Formatters
ss.client.formatters.add(require('ss-coffee'));
ss.client.formatters.add(require('ss-jade'));
ss.client.formatters.add(require('ss-stylus'));

// Use server-side compiled Hogan (Mustache) templates. Others engines available
ss.client.templateEngine.use(require('ss-hogan'));
// ss.client.templateEngine.use(require('ss-clientjade'));

// Minimize and pack assets if you type: SS_ENV=production node app.js
// if (ss.env == 'production'){
  ss.client.packAssets();
// }
// ss.ws.transport.use(require('ss-sockjs'));

function routes(app)
{
    app.get('/', function (req, res) {
        res.serve('main')}
    )
    app.post('/', function (req, res) {
        res.serve('main')}
    )
}

var app = express.createServer(
    ss.http.middleware
,   express.bodyParser()
,   express.router(routes)
)

var port = process.env.PORT || 3000;
var server = app.listen(port);
ss.start(server);
