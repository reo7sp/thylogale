$ = require 'jquery'

focusOnItem = ({next}) ->
  $current = $('.page-folders-list__row--selected')
  if $current[0]
    $next = if next then $current.next() else $current.prev()
    $current.removeClass('page-folders-list__row--selected')
  unless $next?[0]?
    $rows = $('.page-folders-list__row')
    $next = if next then $rows.first() else $rows.last()
  if $next?[0]?
    $next.addClass('page-folders-list__row--selected')
    $(document).scrollTop($next.offset().top)

blurCurrentItem = ->
  $('.page-folders-list__row--selected').removeClass('page-folders-list__row--selected')

$(document).on 'keyup', 'body', (e) ->
  return unless $('body').data('controller') == 'page_folders'
  switch e.keyCode
    when 13 # enter
      href = $('.page-folders-list__row--selected')?.data('href')
      if href
        blurCurrentItem()
        Turbolinks.visit(href)
    when 27 # esc
      history.back()
    when 38 # up
      focusOnItem(next: false)
    when 40 # down
      focusOnItem(next: true)