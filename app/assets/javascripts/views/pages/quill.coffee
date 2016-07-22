require './quill/assetsModule.coffee'
require './quill/autosaveModule.coffee'

pageHandlers = require './page_handlers.coffee'
loadTextToEditor = require './quill/loadTextToEditor.coffee'

isPageView = -> $(document.body).data('controller') == 'pages'


document.addEventListener 'turbolinks:load', ->
  if isPageView()
    $editorEl = $('#page-editor')

    pageId = $editorEl.data('page')
    pageName = $editorEl.data('page-name')

    pageNameExtensions = []
    _(pageName).split('.').reduceRight (acc, it) ->
      acc = "#{it}.#{acc}" if pageNameExtensions.length > 0
      pageNameExtensions.push(acc)

    pageHandlerName = _(pageNameExtensions).find (it) -> pageHandlers[it]?
    pageHandler = pageHandlers[pageHandlerName]

    loadTextToEditor($editorEl, pageHandler)

    quill = new Quill $editorEl[0],
      theme: 'snow'
      modules:
        toolbar: '#page-toolbar'
        assets:
          pageId: pageId
        autosave:
          pageId: pageId
          pageHandler: pageHandler
