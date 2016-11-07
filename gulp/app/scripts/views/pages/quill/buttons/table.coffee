$ = require 'jquery'

module.exports = (quill, $toolbar) ->
  $toolbarTableButton = $ """
      <button type="button" class="ql-table">
        <span class="glyphicon glyphicon-th" aria-hidden="true"></span>
      </button>
      """

  $toolbarTableButton.click ->
    # TODO

  $toolbarBlockquoteButton = $toolbar.find('.ql-blockquote')
  $toolbarTableButton.insertBefore($toolbarBlockquoteButton)

