$ = require 'jquery'
I18n = require 'i18n-js'
Quill = require 'quill'

PageModel = require '../../page_model.coffee'
SavingModal = require '../../saving_modal.coffee'


Quill.register 'modules/publish', class extends Quill.import('core/module')
  constructor: (quill, options) ->
    super
    # @options.pageId # Required

    @$publishPageButton ?= $('#publish-page-button')
    @$publishAllPagesSuffixButton ?= $('#publish-all-pages-suffix-button')
    @$publishAllPagesButton ?= $('#publish-all-pages-button')

    @page = new PageModel(@options.pageId)
    @otherPagesPublished = not @$publishAllPagesButton.hasClass('publish-button__hidden') or not @$publishAllPagesSuffixButton.hasClass('publish-button__hidden')
    @savingModal = new SavingModal

    @fixPublishButton()

    $(document).on('click', '#publish-page-button', @onPublishPageClick.bind(@))
    $(document).on('click', '#publish-all-pages-button', @onPublishAllPagesClick.bind(@))

  publish: ->
    @page.publish()

  publishAll: ->
    PageModel.publishAll()

  onPublishPageClick: ->
    @_savePage()
      .done =>
        @savingModal.toggle(true)
        @savingModal.setProgress(10)
        @savingModal.setTitle(I18n.t('publishing'))
        @publish()
          .progress (percent) =>
            @savingModal.setProgress(percent)
          .always =>
            @savingModal.setProgress(100)
            @savingModal.toggle(false)
            setTimeout((=> @savingModal.setDefaultTitle()), 400)
        @togglePublishButton(false)

  onPublishAllPagesClick: ->
    @_savePage()
      .done =>
        @savingModal.toggle(true)
        @savingModal.setProgress(10)
        @savingModal.setTitle(I18n.t('publishing'))
        @publishAll()
          .progress (percent) =>
            @savingModal.setProgress(percent)
          .always =>
            @savingModal.setProgress(100)
            @savingModal.toggle(false)
            setTimeout((=> @savingModal.setDefaultTitle()), 400)
        @togglePublishAllPagesButton(false)

  _savePage: ->
    @autosaveModule ?= @quill.getModule('autosave') ? false
    return unless @autosaveModule
    if @autosaveModule.willSaveSoon()
      @autosaveModule.savePageNow()
    else
      promise = $.Deferred()
      promise.resolve()
      promise

  togglePublishButton: (show) ->
    if show
      @$publishPageButton.removeClass('publish-button__hidden')
      if @otherPagesPublished
        @$publishAllPagesButton.addClass('publish-button__hidden')
        @$publishAllPagesSuffixButton.removeClass('publish-button__hidden')
      else
        @$publishAllPagesSuffixButton.addClass('publish-button__hidden')
      @fixPublishButton()
    else
      @$publishPageButton.addClass('publish-button__hidden')
      if @otherPagesPublished
        @$publishAllPagesSuffixButton.addClass('publish-button__hidden')
        @$publishAllPagesButton.removeClass('publish-button__hidden')

  togglePublishAllPagesButton: (show) ->
    if show
      throw 'Not implemented'
    else
      @$publishPageButton.addClass('publish-button__hidden')
      @$publishAllPagesSuffixButton.addClass('publish-button__hidden')
      @$publishAllPagesButton.addClass('publish-button__hidden')

  fixPublishButton: ->
    $('.btn-group').has('.btn:hidden').find('.btn:visible:first').css
      'border-top-left-radius': '3px'
      'border-bottom-left-radius': '3px'
    $('.btn-group').has('.btn:hidden').find('.btn:visible:last').css
      'border-top-right-radius': '3px'
      'border-bottom-right-radius': '3px'
