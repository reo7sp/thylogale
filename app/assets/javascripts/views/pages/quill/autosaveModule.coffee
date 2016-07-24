sendPage = (page, data) ->
  form = new FormData
  form.append('page[data]', data)

  $.ajax "/pages/#{page}",
    method: 'PUT'
    data: form
    contentType: false
    processData: false

updateStatus = (message, type) ->
  allTypes = ['ok', 'error']

  $el = $('#page-status')
  $el.html(message)
  $el.removeClass("page-status__#{it}") for it in allTypes
  $el.addClass("page-status__#{type}")

savePage = (page, data) ->
  sendPage(page, data)
    .done ->
      updateStatus(I18n.t('saved'), 'ok')
    .fail ->
      updateStatus(I18n.t('wasnt_saved'), 'error')


Quill.register 'modules/autosave', class extends Quill.import('core/module')
  constructor: (quill, options) ->
    super
    @options.saveTimeoutSeconds ?= 5
    @saveTimeouts = {}
    @quill.on(Quill.events.TEXT_CHANGE, @onTextChange.bind(@))

  onTextChange: (delta, oldDelta, source) ->
    @removeSaveTimeout()
    @createSaveTimeout()

  removeSaveTimeout: ->
    t = @saveTimeouts[@options.pageId]
    clearTimeout(t) if t?
    updateStatus('')

  createSaveTimeout: ->
    @saveTimeouts[@options.pageId] = setTimeout(
      => savePage(@options.pageId, @options.pageHandler.revert(@quill.root.innerHTML))
      @options.saveTimeoutSeconds * 1000
    )
