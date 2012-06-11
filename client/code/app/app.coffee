total = 0
totalLoad = 0
$loader = ''
$target = ''
loaderRunning = false

animateFunc = ->
  unless loaderRunning then return
  total += 1
  $loader.setProgress total / totalLoad
  $loader.setValue(total.toString() + "/" + totalLoad.toString())

initLoading = (element, target) ->
  $target = $(target)
  $(element).show()
  $('.gallery').append('<div class="loader"></div>') unless $('.gallery .loader').length > 0
  $loader = $(element).percentageLoader(
    width: 256
    height: 256
    controllable: false
    progress: 0.0
    onProgressUpdate: (val) ->
      perVal = Math.round(val * 100.0)
      $loader.setValue perVal
  )
  setTimeout( ->
    dfd = $target.imagesLoaded()
    loaderRunning = true
    $loader.setProgress 0
    $loader.setValue ""
    total = 0
    totalLoad = $target.find('img').length
    dfd.always ->
      $loader.fadeOut('slow')
      mul = 1
      $('.gallery li').each ->
        $(this).removeAttr('class').addClass('animated')
    dfd.progress ->
      animateFunc()
  , 500)

hoverAnimation = 'flip hover'
window.jsonAPI = jsonAPI = "http://api.flickr.com/services/feeds/photos_public.gne?tagmode=any&format=json&jsoncallback=?"
keyword = ''

$('input').blur ->
  if $(this).val() == ''
    $(this).parents('li').addClass('error').removeClass('success')
  else
    $(this).parents('li').addClass('success').removeClass('error')

# $('.labels').arctext
#   radius: 62
#   # rotate: false
#   direction: -1

gallery = $('#cate')
sections = $('.sections', $(gallery))
items = $('li', $(sections))
body = $('body')
wrapper = $('#imageList')


# sections.each ->
#   ele = $(this)
#   gallery.delay(100)

body.on 'click', '#images a', ->
  ele=$(this)
  showForm(ele)
  false

$('body').on 'click', '.subgallery li', ->
  ele = $(this)
  keyword = ele.find('img').attr('rel')
  wrapper.data('keyword', keyword)
  jsonAPI = window.jsonAPI
  loadSubGallery(keyword)

body.on 'click', '.gallery li', ->
  ele = $(this)
  keyword = ele.find('img').attr('rel')
  wrapper.data('keyword', keyword)

  setTimeout ->
    ele.addClass('hinge')
  , 1500

  setTimeout ->
    gallery.addClass('selected')
    gallery.find('li').hide().attr('class', '').unwrap()
    setTimeout ->
      showChild()
    , 500
  , 4000

  aniRow('fadeOutUpBig', ele)

aniRow = (cssClass, ele = null) ->
  currentRow = 0
  effTimer = setInterval ->
    currentSec = sections.eq(currentRow)
    return unless currentSec.length isnt 0
    currentSec.find('li')
    .not(ele)
    .addClass(cssClass)
    currentRow++
  , 500

showChild = () ->
    wrapper.addClass('fixoverflow')
    gallery.removeClass('selected gallery')
    .addClass('subgallery animated')
    setTimeout ->
      loadSubGallery(keyword)
      gallery.find('li').each (index, ele)->
        $(this).addClass('rotateIn')
        .css('display', 'inline-block')
    , 1300

makeHover = () ->
  gallery = $('.gallery')
  sections = $('.sections', $(gallery))
  items = $('li', $(sections))
  items.addClass("animated")

  $('.gallery').lionbars ->
    reachedBottom: ->
      loadMore()

  gallery.addClass('ohno')
  gallery.hoverIntent ->
    ele = $(this)
    ele.addClass 'hover'
  , ->
    ele = $(this)
    ele.removeClass 'hover'

  items.hoverIntent ->
    ele = $(this)
    ele.addClass(hoverAnimation)
  , ->
    ele = $(this)
    ele.removeClass(hoverAnimation)

loadSubGallery = (key) ->
  if($('#images').length is 0)
    wrapper.prepend('<div class="gallery" id="images"></div>')
  $('footer, aside').hide()
  $gallery = $('#images')
  initLoading(".loader", ".gallery")
  gallery.html('')
  $.getJSON jsonAPI,
    {tags: key}
    , (data)->
      html = ''
      for i, item in items
        html += ss.tmpl['gallery-item'].render(item: item, i: i)
      $gallery.show().append(html)
      makeHover()

loadMore = () ->
  if $('.loading').length > 0
    return
  console.log 'asd'
  $gallery = $('.gallery').addClass('loading')
  paged = $gallery.data('paged') || 1
  paged++
  $gallery.data('paged', paged)
  key = $('#imageList').data('keyword')
  $.getJSON jsonAPI,
    {tags: key, paged: paged}
    , (data)->
      html = ''
      data.items.each (i, items)->
        html += ss.tmpl['gallery-items'].render(items: items)
      $gallery.removeClass('loading').append('<ul>'+html+'</ul>')

showForm = (ele) ->
  $this = $(this)
  $('footer').fadeIn()
  imgSrc = ele.attr('href')
  $('aside').find('img').remove()
  $('#images').hide()
  $('aside').append('<img src="'+imgSrc+'" />')
  $('aside').slideDown()
  $('#q4').val(imgSrc)
  $('footer .button').unbind('click').bind 'click', ->
    $('aside form').submit()
makeHover()
