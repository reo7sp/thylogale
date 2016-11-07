$ = require 'jquery'
_ = require 'lodash'
Quill = require 'quill'

pageHandlers = require './page_handlers.coffee'

require './quill/formats/custom_class.coffee'
require './quill/formats/table.coffee'

require './quill/modules/autosave.coffee'
require './quill/modules/publish.coffee'

erbButtonMaker = require './quill/buttons/erb.coffee'
pageButtonMaker = require './quill/buttons/page.coffee'
tableButtonMaker = require './quill/buttons/table.coffee'


isPageView = ->
  $(document.body).data('controller') == 'pages'

getPageHandler = (pageName) ->
  _(pageHandlers).find (it) ->
    fileExt = (if it.fileExtension[0] != '.' then '.' else '') + it.fileExtension
    pageName.endsWith(fileExt)


loadData = ($editorEl, pageHandler) ->
  $content = $($editorEl.data('content-in'))
  markdown = _.unescape($content.text())
  html = pageHandler.handle(markdown)
  $editorEl.html(html)

addCustomButtonsToToolbar = (quill, $toolbar) ->
  for buttonMaker in [erbButtonMaker, pageButtonMaker, tableButtonMaker]
    buttonMaker(quill, $toolbar)
  return


document.addEventListener 'turbolinks:load', ->
  return unless isPageView()

  $editorEl = $('#page-editor')
  $toolbarPremade = $('.ql-toolbar')[0]
  pageData = $editorEl.data('page')
  pageHandler = getPageHandler(pageData.name)

  loadData($editorEl, pageHandler)

  quill = new Quill $editorEl[0],
    theme: 'snow'
    modules:
      toolbar: $toolbarPremade ? [
        ['bold', 'italic', 'underline', 'strike']
        [{'script': 'sub'}, {'script': 'super'}]
        [{'color': []}, {'background': []}]
        [{'header': [1, 2, 3, 4, 5, 6, false]}]
        [{'align': []}]
        [{'list': 'ordered'}, {'list': 'bullet'}, {'indent': '-1'}, {'indent': '+1'}]
        ['image', 'link', 'blockquote', 'code-block']
        [{'font': []}]
        [{'size': ['small', false, 'large', 'huge']}]
        ['clean']
      ]
      autosave:
        pageId: pageData.id
        pageHandler: pageHandler
      publish:
        pageId: pageData.id

  unless $toolbarPremade?
    toolbarModule = quill.getModule('toolbar')
    $toolbar = $(toolbarModule.container)
    addCustomButtonsToToolbar(quill, $toolbar)
