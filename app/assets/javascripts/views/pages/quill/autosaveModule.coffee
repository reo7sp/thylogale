savePage = (page, data) ->
  form = new FormData
  form.append('page[data]', data)

  $.ajax "/pages/#{page}",
    method: 'PUT'
    data: form
    contentType: false
    processData: false


Quill.register 'modules/autosave', class extends Quill.import('core/module')
  constructor: (quill, options) ->
    super
    @options.saveTimeoutSeconds ?= 5
    @saveTimeouts = {}
    @quill.on(Quill.events.TEXT_CHANGE, @onTextChange.bind(@))

  onTextChange: (delta, oldDelta, source) ->
    t = @saveTimeouts[@options.pageId]
    clearTimeout(t) if t?
    @saveTimeouts[@options.pageId] = setTimeout(
      => savePage(@options.pageId, @options.pageHandler.revert(@quill.root.innerHTML))
      @options.saveTimeoutSeconds * 1000
    )
