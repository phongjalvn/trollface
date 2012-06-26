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
    'click li'     : 'showGallery'

  constructor: ->
    super

    Gallery.bind 'fetch', =>
      P2.trigger('loader.show')

    Gallery.bind 'refresh', =>
      @render(arguments...)
      @items.addClass('animated')
      setTimeout =>
        P2.trigger('loader.hide') if FBReady?
      , 2000

    @gallery.hover =>
      @gallery.addClass('hover')
    , =>
      @gallery.removeClass('hover')

  render: (items = []) =>
    @html '<ul class="gallery"></ul>'
    for item in items
      @gallery.append ss.tmpl['gallery-item'].render(item)

  showGallery: (e)=>
    ele = $(e.currentTarget)
    @gallery.find('.current').removeClass('current')
    ele.addClass('current')
    P2.trigger('loader.show')
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
