create = ({folder, inFolderWithId}) ->
  swalOpts =
    title: I18n.t "new_#{if folder then 'folder' else 'page'}"
    inputPlaceholder: I18n.t "enter_new_#{if folder then 'folder' else 'page'}"
    type: 'input'

    showCancelButton: true
    allowOutsideClick: true
    closeOnConfirm: false
    showLoaderOnConfirm: true

  swal swalOpts, (title) ->
    if title == false
      return false
    if title == ''
      swal.showInputError(I18n.t 'title_cant_be_empty')
      return false

    p = $.ajax
      url: "/page_folders/#{inFolderWithId}#{if folder then '' else '/pages'}"
      method: 'POST'
      data:
        "#{if folder then 'page_folder' else 'page'}":
          title: title

    p.done ->
      Turbolinks.visit window.location.href, action: 'replace'

    p.fail (e) ->
      console.log e
      swal
        title: I18n.t 'error'
        text: I18n.t "create_#{if folder then 'folder' else 'page'}_fail"
        type: 'error'


moveEntry = (entry, {isFolder}) ->
  # TODO


deleteEntry = (entry, {isFolder}) ->
  p = $.ajax
    url: "/#{if isFolder then 'page_folders' else 'pages'}/#{entry}"
    method: 'DELETE'

  p.done ->
    Turbolinks.visit window.location.href, action: 'replace'

  p.fail (e) ->
    console.log e
    swal
      title: I18n.t 'error'
      text: I18n.t "delete_#{if folder then 'folder' else 'page'}_fail"
      type: 'error'


doWithEntry = (entry, action, {isFolder}) ->
  switch action
    when 'move' then moveEntry(entry, isFolder: isFolder)
    when 'delete' then deleteEntry(entry, isFolder: isFolder)


initCreateButtons = ->
  $(document).on 'click', '#create-page-button', ->
    create(folder: false, inFolderWithId: $(@).data('in-folder'))

  $(document).on 'click', '#create-page-folder-button', ->
    create(folder: true, inFolderWithId: $(@).data('in-folder'))


initList = ->
  $(document).on 'click', '.page-folders-list__row', ->
    Turbolinks.visit $(@).data('href')

  $(document).on 'click', '.page-folders-list__action', ->
    entry = $(@).data('folder')
    isFolder = entry?
    entry ?= $(@).data('page')
    doWithEntry(entry, $(@).data('action'), isFolder: isFolder)


init = ->
  initCreateButtons()
  initList()


init()