$ = require 'jquery'
_ = require 'lodash'
I18n = require 'i18n-js'
Quill = require 'quill'

PageModel = require '../../page_model.coffee'
SavingModal = require '../../saving_modal.coffee'


Quill.register 'modules/autosave', class extends Quill.import('core/module')
  skipNextSave: true

  constructor: (quill, options) ->
    super
    # @options.pageId # Required
    # @options.pageHandler # Required
    @options.saveTimeoutTime ?= 4
    @options.minSavingModelTime = 0.5

    @page = new PageModel(@options.pageId)
    @pageHandler = @options.pageHandler
    @savingModal = new SavingModal

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
      @_showPublishButtons()
      @_createSaveTimeoutImpl()
    @skipNextSave = false

  _showPublishButtons: ->
    @publishModule ?= @quill.getModule('publish') ? false
    return unless @publishModule
    @publishModule.togglePublishButton(true)

  _createSaveTimeoutImpl: ->
    @saveTimeout = setTimeout(@_savePage.bind(@), @options.saveTimeoutTime * 1000)

  removeSaveTimeout: ->
    clearTimeout(@saveTimeout) if @saveTimeout?
    @saveTimeout = null

  willSaveSoon: ->
    @saveTimeout?

  skipSave: (b = true) ->
    @skipNextSave = b

  updatePageStatus: (message, {type} = {}) ->
    allTypes = ['ok', 'error']

    $el = @$pageStatus ?= $('#page-status')
    $el.html(message)
    $el.removeClass("page-status__#{it}") for it in allTypes
    $el.addClass("page-status__#{type}") if type?

  savePageNow: ->
    @removeSaveTimeout()
    @_savePage()

  _savePage: ->
    promise = $.Deferred()
    startTime = Date.now()

    saySuccess = =>
      @quill.enable()
      @updatePageStatus(I18n.t('saved'), type: 'ok')
      @savingModal.toggle(false)
      setTimeout((-> promise.resolve()), 400)

    sayFail = =>
      @quill.enable()
      @updatePageStatus(I18n.t('wasnt_saved'), type: 'error')
      @savingModal.toggle(false)
      setTimeout((-> promise.reject()), 400)

    doAfterMinTime = (f) =>
      elapsedTime = Date.now() - startTime
      setTimeout(f, Math.max(@options.minSavingModelTime * 1000 - elapsedTime, 0))

    doNextFrame = (f) =>
      setTimeout(f, 0)

    @quill.disable()
    @savingModal.setProgress(0)
    @savingModal.toggle(true)

    @page.update(data: @pageHandler.revert(@quill.root.innerHTML))
      .progress (percent) =>
        @savingModal.setProgress(percent * 0.75)
        promise.notify(percent * 0.75)
      .fail =>
        doAfterMinTime(sayFail)
      .done =>
        @savingModal.setProgress(75)
        promise.notify(75)
        @page.raw()
          .done (data) =>
            newHtml = @pageHandler.handle(data)
            $(@quill.root).html(newHtml)
          .progress (percent) =>
            @savingModal.setProgress(75 + percent * 0.25)
            promise.notify(75 + percent * 0.25)
          .always =>
            @savingModal.setProgress(100)
            promise.notify(100)
            doNextFrame(@removeSaveTimeout.bind(@))
            doAfterMinTime(saySuccess)

    promise
