exports.checkAuthenticated = ->
  (req, res, next) ->
    return next()  if req.session and req.session.userId
    res false
