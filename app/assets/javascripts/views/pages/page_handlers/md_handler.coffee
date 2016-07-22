marked = require 'marked'
toMarkdown = require 'to-markdown'

module.exports = class
  fileExtension: 'md'

  handle: (markdown) ->
    marked(markdown)

  revert: (html) ->
    toMarkdown(html, gfm: true)
