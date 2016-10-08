_ = require 'lodash'
ajaxWithProgress = require './ajax_with_progress.coffee'

module.exports = class
  constructor: (@id) ->

  raw: ->
    ajaxWithProgress "/pages/#{@id}/raw"

  update: (dict) ->
    form = new FormData
    for k, v of dict
      form.append("page[#{k}]", v)

    ajaxWithProgress "/pages/#{@id}",
      method: 'PUT'
      data: form
      contentType: false
      processData: false
