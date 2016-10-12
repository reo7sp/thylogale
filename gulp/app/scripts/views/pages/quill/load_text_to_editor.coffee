$ = require 'jquery'


module.exports = ($el, pageHandler) ->
  $content = $($el.data('content-in'))

  $el.html(pageHandler.handle($content.text()))
  $content.remove()
