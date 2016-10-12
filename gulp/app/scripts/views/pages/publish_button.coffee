$ = require 'jquery'
PageModel = require '../pages/page_model.coffee'


$(document).on 'click', '#publish-page-button', () ->
  pageId = $(@).data 'page'
  page = new PageModel(pageId)
  page.publish()
