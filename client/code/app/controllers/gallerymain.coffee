Spine = require('spine')
Gallery = require('/models/gallery')
Galleries = require('/controllers/galleries')
Images = require('/controllers/images')

class GalleryMain extends Spine.Controller
  className: 'main'

  elements:
    '#q4': 'imgVal'
    'aside': 'formHolder'
    'form': 'form'
    '.images-wrapper': 'imgHolder'
    'footer': 'footer'

  events:
    'click .green': 'formHandle'
    'click .red': 'back'
    'blur input': 'formCheck'

  constructor: ->
    super

    Spine.bind 'gallery.show', =>
      @formHolder.slideUp()
      @imgHolder.fadeIn()
      @footer.hide()

    Spine.bind 'gallery.form', (imgurl)=>
      @imgVal.val(imgurl)
      @formHolder.find('img').remove()
      @footer.fadeIn()
      @imgHolder.fadeOut 500, =>
        @formHolder.append("<img src='#{imgurl}'/>").slideDown 500, =>
          @formHolder.css('overflow-y': 'auto')

    @galleries = new Galleries
    @images = new Images

    @render()

  formCheck: (e)=>
    ele = $(e.currentTarget)
    if ele.val() == ''
      ele.parents('li').addClass('error').removeClass('success')
    else
      ele.parents('li').addClass('success').removeClass('error')

  formHandle: (e)=>
    e.preventDefault()
    @form.submit() if @form.find('.success').length >= 3

  back: =>
    @imgHolder.show()
    @footer.hide()
    @imgHolder.scrollTo('.current')
    @formHolder.slideUp()

  render: ->
    templates = ['header', 'aside', @images, @galleries, 'footer']
    for tmpl in templates
      if typeof tmpl is 'string'
        html = ss.tmpl['gallery-'+tmpl].render()
      else
        html = tmpl
      @append html

module.exports = GalleryMain
