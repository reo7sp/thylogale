_ = require 'lodash'

String::tr = (fromStr, toStr) ->
  @replace new RegExp("[#{_.escapeRegExp(fromStr)}]", 'g'), (c) ->
    charsMap = _.zip(Array.from(fromStr), Array.from(toStr))
    charsMap[c]

String::squeeze = (charsRegex = ' ') ->
  @replace new RegExp("#{charsRegex}{2,}", 'g'), ''
