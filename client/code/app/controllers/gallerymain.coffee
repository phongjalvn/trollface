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

  events:
    'click .green': 'formHandle'
    'click .red': 'back'
    'blur input': 'formCheck'

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
      Gallery.fetch()
      @append @images
      @append @galleries
      P2.trigger('loader.hide')
      $('#fb-login').hide()

    P2.bind 'loader.show', =>
      $('.loader').fadeIn()

    P2.bind 'loader.hide', =>
      $('.loader').fadeOut()

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
        P2.trigger('loader.show')
        @footer.fadeIn()
        @formHolder.css('overflow-y', 'auto')
        @formHolder.find('.message').text(title)

    @render()

  # Check form don gian
  formCheck: (e)=>
    ele = $(e.currentTarget)
    if ele.val() == ''
      ele.parents('li').addClass('error').removeClass('success')
    else
      ele.parents('li').addClass('success').removeClass('error')

  # Goi editor ra, an hinh goc, xoa lung tung vai ba thu
  launchEditor: (id, src)=>
    window.featherEditor = new Aviary.Feather(
      apiKey: "b073f6881"
      appendTo: "feather"
      minimumStyling: true
      theme: "black"
      noCloseButton: true
      language: "vi"
      tools: "all"
      maxSize: "670"
      openType: "inline"
      onLoad: ->
        featherEditor.launch
            image: id,
            url: src
        $("##{id}").hide()
      onReady: ->
        $('#avpw_aviary_about').html('<p>Copyright 2012. Vietprotocol</p>')
        P2.trigger('loader.hide')
      onSaveButtonClicked: ->
        P2.trigger('loader.show')
      onError: ->
        $('.message').text('An error occured! Reloading browser...')
        setTimeout ->
          window.localtion = window.location
        , 2000
      onSave: (imageID, newURL) ->
        featherEditor.close()
        img = $("#" + imageID)
        $.post "http://api.imgur.com/2/upload.json",
          key: "6a29ef3026a6c6343b65646f222b2dd2"
          image: newURL
          type: "url"
        , (res) ->
          res = jQuery.parseJSON(res)
          $('.message').text($('aside h3').text())
          img.attr("src", res.upload.links.original).load ->
            img.fadeIn()
            P2.trigger('loader.hide')
            $('aside form').css('display', 'block')
            $("#posttowall, .submit").css "display", "inline-block"
    )

  # This one should named imageHandle instead, but i'm a bit lazy
  # You'll may want to check the libs/tfeather.coffee, there are some hidden sweetness
  formHandle: (e)=>
    e.preventDefault()
    @imgHolder.fadeIn()
    @galleryHolder.fadeIn()
    @formHolder.fadeOut()
    @footer.fadeOut()
    @form.slideUp()
    $('#posttowall').hide()
    imgUrl = $('#featherimage').attr('src')
    message = $('input#message').val()
    # goi ve server de post hinh len wall, co the them params, nhung server chi co the
    # post len facebook theo nhung field qui dinh, vd: name, url
    # Khi post xong se goi tra ve event postSuccess
    ss.rpc 'user.makePost', imgUrl, message, ()->
      P2.trigger('loader.show')

  # User click 'Chon hinh khac' button
  back: =>
    @imgHolder.show()
    @galleryHolder.fadeIn()
    $('footer .submit').hide()
    @imgHolder.scrollTo('.current')
    @formHolder.slideUp()
    @form.slideUp()
    @footer.fadeOut()
    $('#posttowall').hide()
    featherEditor.close()

  # We only need login message and footer (which hold the fuckbook login bastard)
  render: ->
      @append ss.tmpl['gallery-login'].render()
      @append ss.tmpl['gallery-footer'].render()
      @append ss.tmpl['gallery-loader'].render()

module.exports = GalleryMain
