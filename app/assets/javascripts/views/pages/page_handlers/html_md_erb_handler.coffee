_ = require 'lodash'
marked = require 'marked'
toMarkdown = require 'to-markdown'

module.exports = class
  fileExtension: 'html.md.erb'

  handle: (markdown) ->
    marked(markdown)

  revert: (html) ->
    markdownChars = ['\\', '*', '_', '{', '}', '[', ']', '(', ')', '+', '-', '.', '!', '`', '#']
    for c in markdownChars
      html = html.replace(new RegExp(_.escapeRegExp(c), 'g'), '\\' + c)

    randAmpEscapeStr = '\\raes'
    randAmpEscapeStr += Math.random().toString(36).substr(2, 4) while html.includes(randAmpEscapeStr)
    html = html.replace(/&(.+?);/g, "&#{randAmpEscapeStr}$1;")

    result = toMarkdown(html, gfm: true)
    result = result.replace(new RegExp(_.escapeRegExp(randAmpEscapeStr), 'g'), '')
    result
