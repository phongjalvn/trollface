Spine = require('spine')
Gallery = require('/models/gallery')
Image = require('/models/image')

class Galleries extends Spine.Controller
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
        @loader.fadeOut()
      , 2000

    Gallery.fetch()
    @gallery.hover =>
      @gallery.addClass('hover')
    , =>
      @gallery.removeClass('hover')

  render: (items = []) =>
    @html '<ul class="gallery"></ul><div class="loader"></div>'
    for item in items
      @gallery.append ss.tmpl['gallery-item'].render(item)

  mouseover: (e)->
    ele = $(e.currentTarget)

  mouseout: (e)->
    ele = $(e.currentTarget)

  showGallery: (e)=>
    ele = $(e.currentTarget)
    @gallery.find('.current').removeClass('current')
    ele.addClass('current')
    Spine.trigger 'gallery.show', ele.attr('rel')
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
