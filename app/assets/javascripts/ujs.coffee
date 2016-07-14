$(document).on 'click', '[data-reload-current=true]', ->
  Turbolinks.visit window.location.href, action: 'replace'
