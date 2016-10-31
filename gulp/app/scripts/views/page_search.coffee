$ = require 'jquery'
Turbolinks = require 'turbolinks'

doSearch = ->
  query = $('#do-page-search-bar').val()
  Turbolinks.visit "/page_search/#{encodeURIComponent(query)}" if query

exit = ->
  Turbolinks.visit "/"

focusOnItem = ({next}) ->
  $current = $('.page-folders-list__row--selected')
  if $current[0]
    $next = if next then $current.next() else $current.prev()
    $current.removeClass('page-folders-list__row--selected')
  unless $next?[0]?
    $rows = $('.page-folders-list__row')
    $next = if next then $rows.first() else $rows.last()
  $next.addClass('page-folders-list__row--selected')
  $(document).scrollTop($next.offset().top)

blurCurrentItem = ->
  $('.page-folders-list__row--selected').removeClass('page-folders-list__row--selected')

$(document).on 'focus', '#do-page-search-bar', (e) ->
  $(document).scrollTop(0)
  blurCurrentItem()

$(document).on 'keyup', '#do-page-search-bar', (e) ->
  switch e.keyCode
    when 13 # enter
      doSearch()
    when 38, 40 # up, down
      $(@).blur()

$(document).on 'keyup', 'body', (e) ->
  return unless $(@).data('controller') == 'page_search'
  switch e.keyCode
    when 13 # enter
      href = $('.page-folders-list__row--selected')?.data('href')
      if href
        blurCurrentItem()
        Turbolinks.visit(href)
    when 27 # esc
      exit()
    when 38 # up
      focusOnItem(next: false)
    when 40 # down
      focusOnItem(next: true)
    else
      $('#do-page-search-bar').focus()

$(document).on('click', '#do-page-search-button', doSearch)
$(document).on('click', '#exit-page-search-button', exit)
