$ = require 'jquery'
_ = require 'lodash'
Quill = require 'quill'

require './quill/autosave_module.coffee'
pageHandlers = require './page_handlers.coffee'
loadTextToEditor = require './quill/load_text_to_editor.coffee'


isPageView = ->
  $(document.body).data('controller') == 'pages'

getPageHandler = (pageName) ->
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
        toolbar: [
          ['bold', 'italic', 'underline', 'strike']
          [{'script': 'sub'}, {'script': 'super'}]
          [{'color': []}, {'background': []}]

          [{'header': [1, 2, 3, 4, 5, 6, false]}]
          [{'align': []}]

          [{'list': 'ordered'}, {'list': 'bullet'}, {'indent': '-1'}, {'indent': '+1'}]
          ['link', 'image', 'blockquote', 'code-block']

          [{'font': []}]
          [{'size': ['small', false, 'large', 'huge']}]

          ['clean']
        ]
        autosave:
          pageId: pageData.id
          pageHandler: pageHandler
