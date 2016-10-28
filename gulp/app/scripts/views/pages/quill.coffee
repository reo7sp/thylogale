$ = require 'jquery'
_ = require 'lodash'
Quill = require 'quill'

pageHandlers = require './page_handlers.coffee'

require './quill/formats/custom_class.coffee'
require './quill/modules/autosave.coffee'
require './quill/modules/publish.coffee'


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

    $content = $($editorEl.data('content-in'))
    markdown = _.unescape($content.text())
    html = pageHandler.handle(markdown)
    $editorEl.html(html)

    quill = new Quill $editorEl[0],
      theme: 'snow'
      modules:
        toolbar: $('.ql-toolbar')[0] ? [
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
        publish:
          pageId: pageData.id

    toolbarModule = quill.getModule('toolbar')
    $toolbar = $(toolbarModule.container)

    $toolbarErbButton = $ """
        <span class="ql-formats">
          <button type="button" class="ql-erb">
            <span style="font-weight: 900; font-family: Verdana; font-size: 1.15rem; letter-spacing: -4px; line-height: 16px; margin-left: -6px; vertical-align: top">&lt;%</span>
          </button>
        </span>
    """
    $toolbarErbButton.click ->
      quill.format('custom', 'erb')
    $toolbarFontButton = $toolbar.find('.ql-font').parent()
    $toolbarErbButton.insertBefore($toolbarFontButton)
