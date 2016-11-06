$ = require 'jquery'

module.exports = (quill, $toolbar) ->
  $toolbarErbButton = $ """
      <span class="ql-formats">
        <button type="button" class="ql-erb">
          <span style="font-weight: 900; font-family: Verdana; font-size: 1.15rem; letter-spacing: -4px; line-height: 16px; margin-left: -6px; vertical-align: top">&lt;%</span>
        </button>
      </span>
      """

  $toolbarErbButton.click ->
    quill.format('custom', 'erb')

  $toolbarFontButton = $toolbar.find('.ql-font').parent()
  $toolbarErbButton.insertBefore($toolbarFontButton)

