_ = require 'lodash'
PageModel = require '../page_model.coffee'
ajax = require '../ajax_with_progress.coffee'
I18n = require 'i18n-js'
Quill = require 'quill'


updatePageStatus = (message, {type} = {}) ->
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

setSavingModalProgress = (percent) ->
  $el = $('#saving-modal-progress-bar')
  $el.attr('attr-valuenow', percent)
  $el.css('width', "#{percent}%")
  $el.html("#{percent}%")

savePageGracefully = (pageId, data, {$quillRoot, pageHandler, skipSaveFn}) ->
  minSavingModelTime = 500
  startTime = Date.now()

  saySuccess = ->
    updatePageStatus(I18n.t('saved'), type: 'ok')
    toggleSavingModal(false)

  sayFail = ->
    updatePageStatus(I18n.t('wasnt_saved'), type: 'error')
    toggleSavingModal(false)

  doAfterMinTime = (f) ->
    elapsedTime = Date.now() - startTime
    setTimeout(f, Math.max(minSavingModelTime - elapsedTime, 0))

  doNextFrame = (f) ->
    setTimeout(f, 0)

  page = new PageModel(pageId)

  setSavingModalProgress(0)
  toggleSavingModal(true)

  page.update(data: data)
    .progress (percent) ->
      setSavingModalProgress(percent * 0.75)

    .fail ->
      doAfterMinTime(sayFail)

    .done ->
      setSavingModalProgress(75)
      page.raw()
        .done (data) ->
          newHtml = pageHandler.handle(data)
          $quillRoot.html(newHtml)

        .always ->
          setSavingModalProgress(100)
          doAfterMinTime(saySuccess)
          doNextFrame(skipSaveFn)


# quill extension
Quill.registerModule 'modules/autosave', class
  skipNextSave: true

  constructor: (quill, options) ->
    super
    @options.saveTimeoutSeconds ?= 4
    @saveTimeouts = {}
    updatePageStatus(I18n.t('will_autosave'))
    @quill.on(Quill.events.TEXT_CHANGE, @onTextChange.bind(@))

  onTextChange: (delta, oldDelta, source) ->
    @removeSaveTimeout()
    unless @skipNextSave
      updatePageStatus(I18n.t('will_autosave_soon'))
      @createSaveTimeout()
    @skipNextSave = false

  removeSaveTimeout: ->
    t = @saveTimeouts[@options.pageId]
    clearTimeout(t) if t?

  createSaveTimeout: ->
    f = =>
      savePageGracefully(
        @options.pageId
        @options.pageHandler.revert(@quill.root.innerHTML)
        $quillRoot: $(@quill.root)
        pageHandler: @options.pageHandler
        skipSaveFn: @removeSaveTimeout.bind(@)
      )

    @saveTimeouts[@options.pageId] = setTimeout(f, @options.saveTimeoutSeconds * 1000)

  skipSave: (b = true) ->
    @skipNextSave = b
