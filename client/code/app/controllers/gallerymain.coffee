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
    '.message': 'message'
    '.loader': 'loader'

  events:
    'click .green': 'formHandle'
    'click .red': 'back'
    # 'blur input': 'formCheck'

  constructor: ->
    super

    @galleries = new Galleries
    @images = new Images

    ss.event.on 'postSuccess', (res)=>
      P2.trigger('loader.hide')
      mess = ss.tmpl['gallery-posted'].render(message: message.id)
      @imgHolder.prepend mess
      $('.message').last().slideDown().delay(5000).fadeOut 500, ->
        $('.message').remove()

    ss.event.on 'auth', (userId)=>
      @userId = userId
      @message.fadeOut()
      @append @images
      @append @galleries
      $('#fb-login').fadeOut()

    P2.bind 'loader.show', =>
      @loadder.fadeIn()

    P2.bind 'loader.hide', =>
      @loader.fadeOut()

    P2.bind 'gallery.show', =>
      @formHolder.slideUp()
      @imgHolder.fadeIn()
      @footer.hide()

    P2.bind 'gallery.form', (imgurl, title)=>
      @imgUrl = imgurl
      $('footer .submit').show()
      @imgHolder.fadeOut()
      @galleryHolder.fadeOut()
      @formHolder.find('img').remove()
      @formHolder.append("<img src='#{imgurl}' id='featherimage'/>").slideDown 500, =>
        @launchEditor('featherimage', @imgUrl)
        @footer.fadeIn()
        @formHolder.css('overflow-y', 'auto')
        @formHolder.find('.message').text(title)

    @render()

  # Check form don gian
  # formCheck: (e)=>
  #   ele = $(e.currentTarget)
  #   if ele.val() == ''
  #     ele.parents('li').addClass('error').removeClass('success')
  #   else
  #     ele.parents('li').addClass('success').removeClass('error')

  # Goi editor ra, an hinh goc, xoa lung tung vai ba thu
  launchEditor: (id, src)=>
    featherEditor.launch
        image: id,
        url: src
    $("##{id}").hide()
    @checkIma()

  # Don't touch this
  checkIma: (id, src)=>
    setTimeout =>
      ima = $('#avpw_aviary_about')
      if ima.length > 0
        ima.remove()
      else
        @checkIma
    , 500

  # This one should named imageHandle instead, but i'm a bit lazy
  # You'll may want to check the libs/tfeather.coffee, there are some hidden sweetness
  formHandle: (e)=>
    e.preventDefault()
    @imgHolder.fadeIn()
    @galleryHolder.fadeIn()
    @formHolder.fadeOut()
    @footer.fadeOut()
    $('#posttowall').hide()
    imgUrl = $('#featherimage').attr('src')
    # goi ve server de post hinh len wall, co the them params, nhung server chi co the
    # post len facebook theo nhung field qui dinh, vd: name, url
    # Khi post xong se goi tra ve event postSuccess
    ss.rpc 'user.makePost', imgUrl, ()->
      P2.trigger('loader.show')

  # User click 'Chon hinh khac' button
  back: =>
    @imgHolder.show()
    @galleryHolder.fadeIn()
    $('footer .submit').hide()
    @imgHolder.scrollTo('.current')
    @formHolder.slideUp()
    @footer.fadeOut()
    @imgHolder.find('.last').waypoint((e, dir)=>
      @loadgallery()
    , {triggerOnce: true, context: '.images-wrapper', offset: '100%'}
    )
    $('#posttowall').hide()
    featherEditor.close()

  # We only need login message and footer (which hold the fuckbook login bastard)
  render: ->
      @append ss.tmpl['gallery-login'].render()
      @append ss.tmpl['gallery-footer'].render()

module.exports = GalleryMain
