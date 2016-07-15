module.exports = -> new class
  constructor: ->
    doWithEntry = @doWithEntry.bind(@)

    $(document).on 'click', '.page-folders-list__row', ->
      Turbolinks.visit $(@).data('href')

    $(document).on 'click', '.page-folders-list__action', ->
      entry = $(@).data('folder')
      isFolder = entry?
      entry ?= $(@).data('page')
      doWithEntry(entry, $(@).data('action'), {isFolder})

  doWithEntry: (entry, action, {isFolder}) ->
    switch action
      when 'move' then @moveEntry(entry, {isFolder})
      when 'delete' then @deleteEntry(entry, {isFolder})
      
  moveEntry: (entry, {isFolder}) ->
    # TODO

  deleteEntry: (entry, {isFolder}) ->
    p = $.ajax
      url: "/#{if isFolder then 'page_folders' else 'pages'}/#{entry}"
      method: 'DELETE'

    p.done ->
      Turbolinks.visit window.location.href, action: 'replace'

    p.fail (e) ->
      console.log e
      swal
        title: I18n.t 'error'
        text: I18n.t "delete_#{if isFolder then 'folder' else 'page'}_fail"
        type: 'error'
