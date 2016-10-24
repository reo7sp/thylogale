$ = require 'jquery'
_ = require 'lodash'


module.exports = (url, opts = {}) ->
  promise = $.Deferred()

  ajaxPromise = $.ajax url, _.assign opts,
    xhr: ->
      xhr = new XMLHttpRequest
      xhr.upload.addEventListener "progress", (e) ->
        if e.lengthComputable
          percent = parseInt((e.loaded / e.total) * 100)
          promise.notify(percent)
      xhr

  ajaxPromise.done -> promise.resolve(arguments...)
  ajaxPromise.fail -> promise.reject(arguments...)

  promise
