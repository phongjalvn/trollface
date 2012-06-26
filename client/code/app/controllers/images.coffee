P2 = require('p2')
Image = require('/models/image')

class Images extends P2.Controller
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

    P2.bind 'gallery.show', (cate)=>
      @html '<ul class="gallery"></ul><div class="loader"></div>'
      Image.cate = cate
      Image.page = 0
      @loadgallery()

    Image.bind 'fetch', =>
      P2.trigger('loader.show')

    Image.bind 'refresh', =>
      @render(arguments...)
      @items.addClass('animated')
      setTimeout =>
        P2.trigger('loader.hide')
      , 2000

    @el.hover =>
      @el.addClass('hover')
    , =>
      @el.removeClass('hover')

  render: (items = []) =>
    for item in items
      @gallery.append ss.tmpl['gallery-image'].render(item)

  loadgallery: =>
    if Image.lastPage then return
    if Image.page > 0
      Image.fetch(Image.cate, ':page', Image.page)
    else
      Image.fetch(Image.cate)
    Image.page++

  showForm: (e)=>
    e.preventDefault()
    ele = $(e.currentTarget)
    @gallery.find('.current').removeClass('current')
    ele.parents('li').addClass('current')
    imgurl = ele.attr('href')
    title = ele.find('.labels').text()
    P2.trigger 'gallery.form', imgurl, title

module.exports = Images
