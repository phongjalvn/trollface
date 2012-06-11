Spine = require('spine')
Image = require('/models/image')

class Images extends Spine.Controller
  className: 'images-wrapper'

  elements:
    'ul.gallery': 'gallery'
    '.scroller': 'scroller'
    'li': 'items'
    '.loader': 'loader'

  events:
    'click a': 'showForm'

  constructor: ->
    super

    Spine.bind 'gallery.show', (cate)=>
      @html '<ul class="gallery"></ul><div class="loader"></div>'
      Image.cate = cate
      Image.page = 0
      @loadgallery()

    Image.bind 'fetch', =>
      @el.addClass('loading')

    Image.bind 'refresh', =>
      @render(arguments...)
      @items.addClass('animated')
      setTimeout =>
        @loader.fadeOut()
      , 2000

    @el.hover =>
      @el.addClass('hover')
    , =>
      @el.removeClass('hover')

  render: (items = []) =>
    for item in items
      oriwidth = item.width
      item.width = @gallery.width() / 5 - 13
      @gallery.append ss.tmpl['gallery-image'].render(item)

    @gallery.append '<li class="last">Load more...</li>'

    @lastrow = @gallery.find('li.last')
    @lastrow.waypoint((e, dir)=>
      console.log 'asd'
      @loadgallery()
      @lastrow.remove()
    , {triggerOnce: true, context: '.images-wrapper', offset: '100%'}
    )
    .click (e)=>
      console.log 'asd'
      @loadgallery()
      @lastrow.remove()

  loadgallery: =>
    @loader.fadeIn()
    if Image.page > 0
      Image.fetch(Image.cate, 'page', Image.page)
    else
      Image.fetch(Image.cate)
    Image.page++

  showForm: (e)=>
    e.preventDefault()
    ele = $(e.currentTarget)
    @gallery.find('.current').removeClass('current')
    ele.parents('li').addClass('current')
    imgurl = ele.attr('href')
    Spine.trigger 'gallery.form', imgurl

module.exports = Images
