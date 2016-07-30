_ = require 'lodash'

ajax = (url, opts) ->
  deferred = $.Deferred()

  ajaxPromise = $.ajax url, _.assign opts,
    xhr: ->
      xhr = new XMLHttpRequest
      xhr.upload.addEventListener "progress", (e) ->
        if e.lengthComputable
          percent = parseInt((e.loaded / e.total) * 100)
          deferred.notify(percent)
      xhr

  ajaxPromise.done (opts...) -> deferred.resolve(opts...)
  ajaxPromise.fail (opts...) -> deferred.reject(opts...)

  deferred

sendPage = (page, data) ->
  form = new FormData
  form.append('page[data]', data)

  ajax "/pages/#{page}",
    method: 'PUT'
    data: form
    contentType: false
    processData: false

updateStatus = (message, type) ->
  allTypes = ['ok', 'error']

  $el = $('#page-status')
  $el.html(message)
  $el.removeClass("page-status__#{it}") for it in allTypes
  $el.addClass("page-status__#{type}") if type?

toggleSavingModal = (show) ->
  $el = $('#saving-modal')
  if show
    $el.removeClass('saving-modal_hidden')
  else
    setTimeout((-> $el.addClass('saving-modal_hidden')), 250)
  setTimeout((-> $el.toggleClass('saving-modal_transparent', !show)), 0)

setSavingModelProgress = (percent) ->
  $el = $('#saving-modal-progress-bar')
  $el.attr('attr-valuenow', percent)
  $el.css('width', "#{percent}%")
  $el.html("#{percent}%")

savePage = (page, data, $quillRoot, pageHandler, skipSaveFn) ->
  onDone = ->
    updateStatus(I18n.t('saved'), 'ok')
    toggleSavingModal(false)

  onFail = ->
    updateStatus(I18n.t('wasnt_saved'), 'error')
    toggleSavingModal(false)

  minSavingModelTime = 500
  startTime = Date.now()
  setSavingModelProgress(0)
  toggleSavingModal(true)

  sendPage(page, data)
    .progress (percent) ->
      setSavingModelProgress(percent)

    .fail ->
      elapsedTime = Date.now() - startTime
      if elapsedTime < minSavingModelTime
        setTimeout(onFail, minSavingModelTime - elapsedTime)
      else
        onFail()

    .done ->
      setSavingModelProgress(100)
      ajax "/pages/#{page}/raw"
        .done (data) ->
          $quillRoot.html(pageHandler.handle(data))

        .always ->
          elapsedTime = Date.now() - startTime
          setTimeout(onDone, Math.max(minSavingModelTime - elapsedTime, 0))
          setTimeout((-> skipSaveFn()), 0)


Quill.register 'modules/autosave', class extends Quill.import('core/module')
  skipNextSave: true

  constructor: (quill, options) ->
    super
    @options.saveTimeoutSeconds ?= 4
    @saveTimeouts = {}
    updateStatus(I18n.t('will_autosave'))
    @quill.on(Quill.events.TEXT_CHANGE, @onTextChange.bind(@))

  onTextChange: (delta, oldDelta, source) ->
    @removeSaveTimeout()
    unless @skipNextSave
      updateStatus(I18n.t('will_autosave_soon'))
      @createSaveTimeout()
    @skipNextSave = false

  removeSaveTimeout: ->
    t = @saveTimeouts[@options.pageId]
    clearTimeout(t) if t?

  createSaveTimeout: ->
    f = =>
      savePage(
        @options.pageId
        @options.pageHandler.revert(@quill.root.innerHTML)
        $(@quill.root)
        @options.pageHandler
        @removeSaveTimeout.bind(@)
      )

    @saveTimeouts[@options.pageId] = setTimeout(f, @options.saveTimeoutSeconds * 1000)

  skipSave: (b = true) ->
    @skipNextSave = b
