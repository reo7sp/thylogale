$ = require 'jquery'
I18n = require 'i18n-js'

module.exports = (quill, $toolbar) ->
  $toolbarPageButton = $ """
      <button type="button" class="ql-page">
        <span class="glyphicon glyphicon-file" aria-hidden="true"></span>
      </button>
      """

  $toolbarPageButton.click ->
    initialSelection = quill.getSelection()

    $tooltip = $ """
        <div class="page-ql-page-search-tooltip">
          <span class="page-ql-page-search-tooltip__text">#{I18n.t 'enter_page_title'}</span>
          <input type="text" class="page-ql-page-search-tooltip__input">
          <a class="page-ql-page-search-tooltip__btn page-ql-page-search-tooltip__search-btn">#{I18n.t 'search'}</a>
          <a class="page-ql-page-search-tooltip__btn page-ql-page-search-tooltip__close-btn">#{I18n.t 'close'}</a>

          <hr class="page-ql-page-search-tooltip__separator page-ql-page-search-tooltip__separator_hidden">

          <ul class="page-ql-page-search-tooltip__list">
          </ul>
        </div>
        """

    $tooltip.css('left', $toolbarPageButton.offset().left)
    $tooltip.css('top', $toolbarPageButton.offset().top + 16)

    $input = $tooltip.find('.page-ql-page-search-tooltip__input')
    $searchBtn = $tooltip.find('.page-ql-page-search-tooltip__search-btn')
    $closeBtn = $tooltip.find('.page-ql-page-search-tooltip__close-btn')
    $separator = $tooltip.find('.page-ql-page-search-tooltip__separator')
    $list = $tooltip.find('.page-ql-page-search-tooltip__list')

    $searchBtn.click ->
      $separator.removeClass('page-ql-page-search-tooltip__separator_hidden')

      $loading = $ """
          <li class="page-ql-page-search-tooltip__list-item">
            <span class="page-ql-page-search-tooltip__list-item-text">
              <img src='/assets/images/loading.gif' style='height: 1em'> #{I18n.t 'searching'}
            </span>
          </li>
      """
      $list.empty()
      $list.append($loading)

      query = $input.val()
      $.ajax "/page_search/#{encodeURI(query)}.json"
        .done (data) ->
          $list.empty()
          if data?.result?.pages?.length > 0
            for item in data.result.pages
              $item = $ """
                  <li class="page-ql-page-search-tooltip__list-item">
                    <span class="page-ql-page-search-tooltip__list-item-text">
                      <span class="glyphicon glyphicon-file" aria-hidden="true"></span> #{item.title}
                    </span>
                    <a class="page-ql-page-search-tooltip__list-item-btn">#{I18n.t 'use'}</a>
                  </li>
                  """
              $useButton = $item.find('.page-ql-page-search-tooltip__list-item-btn')
              $useButton.click ->
                selection = quill.getSelection() ? initialSelection ? {}
                if selection.length? and selection.length > 0
                  quill.format('link', item.build_path, 'user')
                else
                  quill.insertText(selection.index ? 0, item.title, 'link', item.build_path, 'user')
                $tooltip.remove()
              $list.append($item)
          else
            $notFoundText = $ """
                <li class="page-ql-page-search-tooltip__list-item">
                  <span class="page-ql-page-search-tooltip__list-item-text">
                    #{I18n.t 'not_found'}
                  </span>
                </li>
                """
            $list.append($notFoundText)
      .fail ->
        $list.empty()
        $errorText = $ """
            <li class="page-ql-page-search-tooltip__list-item">
              <span class="page-ql-page-search-tooltip__list-item-text">
                #{I18n.t 'search_error'}
              </span>
            </li>
            """
        $list.append($errorText)

    $closeBtn.click ->
      $tooltip.remove()

    $('.container').append($tooltip)

  $toolbarImageButton = $toolbar.find('.ql-image')
  $toolbarPageButton.insertBefore($toolbarImageButton)
