$ = require 'jquery'
_ = require 'lodash'
require './quill/autosave_module.coffee'
pageHandlers = require './page_handlers.coffee'
loadTextToEditor = require './quill/load_text_to_editor.coffee'


isPageView = ->
  $(document.body).data('controller') == 'pages'

getPageHandler = (pageName) ->
  console.log pageHandlers
  _(pageHandlers).find (it) ->
    fileExt = (if it.fileExtension[0] != '.' then '.' else '') + it.fileExtension
    pageName.endsWith(fileExt)


document.addEventListener 'turbolinks:load', ->
  if isPageView()
    $editorEl = $('#page-editor')
    pageData = $editorEl.data('page')
    pageHandler = getPageHandler(pageData.name)

    loadTextToEditor($editorEl, pageHandler)

    quill = new Quill $editorEl[0],
      theme: 'snow'
      modules:
        toolbar: '#page-toolbar'
        autosave:
          pageId: pageData.id
          pageHandler: pageHandler
