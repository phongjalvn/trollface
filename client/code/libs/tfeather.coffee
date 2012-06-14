featherEditor = new Aviary.Feather(
  apiKey: "b073f6881"
  appendTo: "feather"
  minimumStyling: true
  # maxSize: 1000
  theme: "black"
  noCloseButton: true
  language: "vi"
  tools: "all"
  openType: "inline"
  onSave: (imageID, newURL) ->
    featherEditor.close()
    # makeURLItem newURL
    img = $("#"+imageID)
    ss.rpc('user.saveImage', newURL, (res)->
      img.attr('src', res.upload.links.original).load ->
        img.fadeIn()
        $('#posttowall').fadeIn()
    )
)
