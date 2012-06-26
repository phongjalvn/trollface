P2 = @P2 or require('p2')

class Controller extends P2.Controller
  render: =>
    @html ss.tmpl["#{@template}-#{@view}"].render(@)

module.exports = Controller
