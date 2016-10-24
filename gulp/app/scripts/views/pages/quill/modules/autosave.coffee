$ = require 'jquery'
_ = require 'lodash'
I18n = require 'i18n-js'
Quill = require 'quill'

PageModel = require '../../page_model.coffee'


Quill.register 'modules/autosave', class extends Quill.import('core/module')
  skipNextSave: true

  constructor: (quill, options) ->
    super

    @options.saveTimeoutTime ?= 4
    @options.minSavingModelTime = 0.5
    @updatePageStatus(I18n.t('will_autosave'))

    @quill.on(Quill.events.TEXT_CHANGE, @onTextChange.bind(@))
    $(document).on('click', '.ql-toolbar', @onFormatClick.bind(@))

  onTextChange: ->
    @createSaveTimeout()

  onFormatClick: ->
    @createSaveTimeout() if @saveTimeout?

  createSaveTimeout: ->
    @removeSaveTimeout()
    unless @skipNextSave
      @updatePageStatus(I18n.t('will_autosave_soon'))
      @_createSaveTimeoutImpl()
    @skipNextSave = false

  _createSaveTimeoutImpl: ->
    @saveTimeout = setTimeout(@savePage.bind(@), @options.saveTimeoutTime * 1000)

  removeSaveTimeout: ->
    clearTimeout(@saveTimeout) if @saveTimeout?
    @saveTimeout = null

  skipSave: (b = true) ->
    @skipNextSave = b

  updatePageStatus: (message, {type} = {}) ->
    allTypes = ['ok', 'error']

    $el = $('#page-status')
    $el.html(message)
    $el.removeClass("page-status__#{it}") for it in allTypes
    $el.addClass("page-status__#{type}") if type?

  toggleSavingModal: (show) ->
    $el = $('#saving-modal')
    if show
      $el.removeClass('saving-modal_hidden')
    else
      setTimeout((-> $el.addClass('saving-modal_hidden')), 250)
    setTimeout((-> $el.toggleClass('saving-modal_transparent', !show)), 0)

  setSavingModalProgress: (percent) ->
    $el = $('#saving-modal-progress-bar')
    $el.attr('attr-valuenow', percent)
    $el.css('width', "#{percent}%")
    $el.html("#{percent}%")

  savePage: ->
    startTime = Date.now()

    saySuccess = =>
      @quill.enable()
      @updatePageStatus(I18n.t('saved'), type: 'ok')
      @toggleSavingModal(false)

    sayFail = =>
      @quill.enable()
      @updatePageStatus(I18n.t('wasnt_saved'), type: 'error')
      @toggleSavingModal(false)

    doAfterMinTime = (f) =>
      elapsedTime = Date.now() - startTime
      setTimeout(f, Math.max(@options.minSavingModelTime * 1000 - elapsedTime, 0))

    doNextFrame = (f) =>
      setTimeout(f, 0)

    page = new PageModel(@options.pageId)

    @quill.disable()
    @setSavingModalProgress(0)
    @toggleSavingModal(true)

    page.update(data: @options.pageHandler.revert(@quill.root.innerHTML))
      .progress (percent) =>
        @setSavingModalProgress(percent * 0.75)
      .fail =>
        doAfterMinTime(sayFail)
      .done =>
        @setSavingModalProgress(75)
        page.raw()
          .done (data) =>
            newHtml = @options.pageHandler.handle(data)
            $(@quill.root).html(newHtml)
          .progress (percent) =>
            @setSavingModalProgress(75 + percent * 0.25)
          .always =>
            @setSavingModalProgress(100)
            doAfterMinTime(saySuccess)
            doNextFrame(@removeSaveTimeout.bind(@))
