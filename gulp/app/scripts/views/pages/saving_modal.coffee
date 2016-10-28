$ = require 'jquery'
I18n = require 'i18n-js'

module.exports = class
  constructor: (@$savingModal = $('#saving-modal'), @$savingModalMessage = $('#saving-modal-message'), @$savingModalProgressBar = $('#saving-modal-progress-bar')) ->

  toggle: (show) ->
    $el = @$savingModal
    if show
      $el.removeClass('saving-modal_hidden')
    else
      setTimeout((-> $el.addClass('saving-modal_hidden')), 250)
    setTimeout((-> $el.toggleClass('saving-modal_transparent', !show)), 0)

  setTitle: (title) ->
    @$savingModalMessage.html(title)

  setDefaultTitle: ->
    @setTitle(I18n.t('saving'))

  setProgress: (percent) ->
    $el = @$savingModalProgressBar
    $el.attr('attr-valuenow', percent)
    $el.css('width', "#{percent}%")
    $el.html("#{percent}%")
