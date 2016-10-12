_ = require 'lodash'
ajax = require './ajax_with_progress.coffee'


module.exports = class
  constructor: (@id) ->
    @urlPath = "/pages/#{@id}"

  raw: ->
    ajax "#{@urlPath}/raw"

  update: (dict) ->
    form = new FormData
    for k, v of dict
      form.append("page[#{k}]", v)

    ajax @urlPath,
      method: 'PUT'
      data: form
      contentType: false
      processData: false

  delete: ->
    ajax @urlPath, method: 'DELETE'

  publish: ->
    ajax "#{@urlPath}/publish", method: 'POST'
