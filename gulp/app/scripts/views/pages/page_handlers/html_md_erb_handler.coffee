_ = require 'lodash'
marked = require 'marked'
toMarkdown = require 'to-markdown'


module.exports = class
  fileExtension: 'html.md.erb'

  handle: (markdown) ->
    marked(markdown).replace(/>\s+</g, '><')

  revert: (html) ->
    markdownEscapeChars = ['\\', '*', '_', '{', '}', '[', ']', '(', ')', '+', '-', '.', '!', '`', '#']
    htmlEscaped = ''
    isInTag = false
    for c in html
      if c == '<'
        isInTag = true
      else if c == '>'
        isInTag = false
      else if not isInTag and markdownEscapeChars.includes(c)
        htmlEscaped += '\\'
      htmlEscaped += c
    html = htmlEscaped

    randAmpEscapeStr = '\\raes'
    randAmpEscapeStr += Math.random().toString(36).substr(2, 4) while html.includes(randAmpEscapeStr)
    html = html.replace(/&(.+?);/g, "&#{randAmpEscapeStr}$1;")

    result = toMarkdown(html, gfm: true)
    result = result.replace(new RegExp(_.escapeRegExp(randAmpEscapeStr), 'g'), '')
    result
