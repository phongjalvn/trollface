P2 = require('p2')
Gallery = require('/models/gallery')
Galleries = require('/controllers/galleries')
Images = require('/controllers/images')

class GalleryMain extends P2.Controller
  className: 'main'

  elements:
    'aside': 'formHolder'
    'form': 'form'
    '.images-wrapper': 'imgHolder'
    'footer .submit': 'footer'
    '.gallery-wrapper': 'galleryHolder'

  events:
    'click .green': 'formHandle'
    'click .red': 'back'
    # 'blur input': 'formCheck'

  constructor: ->
    super

    P2.bind 'gallery.show', =>
      @formHolder.slideUp()
      @imgHolder.fadeIn()
      @footer.hide()


    P2.bind 'gallery.form', (imgurl, title)=>
      if @login then ss.rpc 'user.isLiked', (message)=>
          if message isnt ''
            mess = ss.tmpl['gallery-message'].render(message: message)
            @imgHolder.prepend mess
            $('.message').last().slideDown().delay(1000).fadeOut 500, ->
              $('.message').remove()
          else
            @imgUrl = imgurl
            @imgHolder.fadeOut()
            @galleryHolder.fadeOut()
            @formHolder.find('img').remove()
            @formHolder.append("<img src='#{imgurl}' id='featherimage'/>").slideDown 500, =>
              @launchEditor('featherimage', @imgUrl)
              @footer.fadeIn()
              @formHolder.css('overflow-y', 'auto')
              @formHolder.find('.message').text(title)

    @galleries = new Galleries
    @images = new Images

    @render()

  # formCheck: (e)=>
  #   ele = $(e.currentTarget)
  #   if ele.val() == ''
  #     ele.parents('li').addClass('error').removeClass('success')
  #   else
  #     ele.parents('li').addClass('success').removeClass('error')

  launchEditor: (id, src)=>
    featherEditor.launch
        image: id,
        url: src
    $("##{id}").hide()
    @checkIma()

  checkIma: (id, src)=>
    setTimeout =>
      ima = $('#avpw_aviary_about')
      if ima.length > 0
        ima.remove()
      else
        @checkIma
    , 500

  formHandle: (e)=>
    e.preventDefault()
    @imgHolder.fadeIn()
    @galleryHolder.fadeIn()
    @formHolder.fadeOut()
    @footer.fadeOut()
    $('#posttowall').hide()
    imgUrl = $('#featherimage').attr('src')
    ss.rpc('user.makePost', imgUrl, (message)=>
      mess = ss.tmpl['gallery-posted'].render(message: message.id)
      @imgHolder.prepend mess
      $('.message').last().slideDown().delay(3000).fadeOut 500, ->
        $('.message').remove()
      @back
    )
    # @galleryHolder.fadeOut()
    # launchEditor('featherimage', @imgUrl)
    # @form.submit() if @form.find('.success').length >= 3

  back: =>
    @imgHolder.show()
    @footer.hide()
    @imgHolder.scrollTo('.current')
    @formHolder.slideUp()
    @footer.fadeOut()
    $('#posttowall').hide()
    featherEditor.close()

  render: ->
    templates = ['header', 'aside']
    for tmpl in templates
      if typeof tmpl is 'string'
        html = ss.tmpl['gallery-'+tmpl].render()
      else
        html = tmpl
      @append html

    ss.rpc 'user.getUser', (userId)=>
      if userId?
        @login = userId
        @append @images
        @append @galleries
        @append ss.tmpl['gallery-footerloggedin'].render(userId: userId)
      else
        @append ss.tmpl['gallery-login'].render()
        @append ss.tmpl['gallery-footer'].render()

module.exports = GalleryMain
