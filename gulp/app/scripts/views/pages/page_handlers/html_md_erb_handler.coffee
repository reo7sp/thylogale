_ = require 'lodash'
marked = require 'marked'
toMarkdown = require 'to-markdown'


module.exports = class
  fileExtension: 'html.md.erb'

  markedOptions:
    gfm: true

  toMarkdownOptions:
    gfm: true
    converters: [
      {
        filter: 's'
        replacement: (content) -> "<s>#{content}</s>"
      }
      {
        filter: (node) -> node.classList.contains('ql-custom-erb')
        replacement: (content) -> "<%#{content}%>"
      }
      {
        filter: (node) -> node.classList.length > 0 or node.style.length > 0
        replacement: (content, node) -> node.outerHTML
      }
    ]

  handle: (markdown) ->
    markdown = markdown.replace(/<%(.+?)%>/g, '<span class="ql-custom-erb">$1</span>')

    marked(markdown, @markedOptions)
      .replace(/>\s+</g, '><')

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

    toMarkdown(html, @toMarkdownOptions)
      .replace(new RegExp(_.escapeRegExp(randAmpEscapeStr), 'g'), '')
      .replace(/<span .*?class="ql-custom-erb".*?>(.*?)<\/span>/g, '<%$1%>')
