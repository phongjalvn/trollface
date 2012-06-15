#   __     __     U  ___ u                    _   _       _     _     _
#   \ \   /"/u     \/"_ \/         ___     U |"|u| |    U|"|u U|"|u U|"|u
#    \ \ / //      | | | |        |_"_|     \| |\| |    \| |/ \| |/ \| |/
#    /\ V /_,-..-,_| |_| |         | |       | |_| |     |_|   |_|   |_|
#   U  \_/-(_/  \_)-\___/        U/| |\u    <<\___/      (_)   (_)   (_)
#     //             \\       .-,_|___|_,-.(__) )(       |||_  |||_  |||_
#    (__)           (__)       \_)-' '-(_/     (__)     (__)_)(__)_)(__)_)
#                  _   _     __     __     U  ___ u      _   _     _   _                 _   _       _
#       ___     U |"|u| |    \ \   /"/u     \/"_ \/     | \ |"|   |'| |'|     ___     U |"|u| |    U|"|u
#      |_"_|     \| |\| |     \ \ / //      | | | |    <|  \| |> /| |_| |\   |_"_|     \| |\| |    \| |/
#       | |       | |_| |     /\ V /_,-..-,_| |_| |    U| |\  |u U|  _  |u    | |       | |_| |     |_|
#     U/| |\u    <<\___/     U  \_/-(_/  \_)-\___/      |_| \_|   |_| |_|   U/| |\u    <<\___/      (_)
#  .-,_|___|_,-.(__) )(        //             \\        ||   \\,-.//   \\.-,_|___|_,-.(__) )(       |||_
#   \_)-' '-(_/     (__)      (__)           (__)       (_")  (_/(_") ("_)\_)-' '-(_/     (__)     (__)_)
#
#

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
    img = $("#"+imageID)
    $.post("http://api.imgur.com/2/upload.json",{key: '6a29ef3026a6c6343b65646f222b2dd2', image: newURL, type: 'url'}, (res)->
      img.attr('src', res.upload.links.original).load ->
        img.fadeIn()
        $('#posttowall, .submit').fadeIn()
    )
)
