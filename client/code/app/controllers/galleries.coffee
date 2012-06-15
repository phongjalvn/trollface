P2 = require('p2')
Gallery = require('/models/gallery')
Image = require('/models/image')

class Galleries extends P2.Controller
  className: 'gallery-wrapper'

  elements:
    'ul.gallery' : 'gallery'
    '.scroller'  : 'scroller'
    'li'         : 'items'
    '.loader'    : 'loader'

  events:
    'mouseover li' : 'mouseover'
    'mouseout li'  : 'mouseout'
    'click li'     : 'showGallery'

  constructor: ->
    super

    Gallery.bind 'fetch', =>
      @el.addClass('loading')
      @loader.fadeIn()

    Gallery.bind 'refresh', =>
      @render(arguments...)
      @items.addClass('animated')
      setTimeout =>
        @el.removeClass('loading')
      , 2000

    @gallery.hover =>
      @gallery.addClass('hover')
    , =>
      @gallery.removeClass('hover')

    Gallery.fetch()

  render: (items = []) =>
    @html '<ul class="gallery"></ul>'
    for item in items
      @gallery.append ss.tmpl['gallery-item'].render(item)
    # @append ss.tmpl['gallery-loader'].render()

  mouseover: (e)->
    ele = $(e.currentTarget)

  mouseout: (e)->
    ele = $(e.currentTarget)

  showGallery: (e)=>
    ele = $(e.currentTarget)
    @gallery.find('.current').removeClass('current')
    ele.addClass('current')
    P2.trigger 'gallery.show', ele.attr('rel')
    if !@isShow?
      @isShow = true
      @el.transition
        top: @el.height() - 160 + 70
        'overflow-y': 'hidden'
      , =>
        @gallery.addClass('subgallery')
        @gallery.wrapInner('<div class="scroller"></div>')
        @gallery.find('scroller').scrollTo('.current')

module.exports = Galleries
