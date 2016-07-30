doSearch = ->
  query = $('#do-page-search-bar').val()
  Turbolinks.visit "/page_search/#{encodeURIComponent(query)}" if query

$(document).on 'keypress', '#do-page-search-bar', (e) ->
  doSearch() if e.keyCode == 13

$(document).on 'click', '#do-page-search-button', ->
  doSearch()
