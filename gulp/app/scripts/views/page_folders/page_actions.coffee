$ = require 'jquery'
Turbolinks = require 'turbolinks'
swal = require 'sweetalert'
I18n = require 'i18n-js'


create = ({folder, inFolderWithId}) ->
  swalOpts =
    title: I18n.t "new_#{if folder then 'folder' else 'page'}"
    inputPlaceholder: I18n.t "enter_new_#{if folder then 'folder' else 'page'}"
    cancelButtonText: I18n.t 'cancel'
    confirmButtonText: I18n.t 'ok'
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
      url: "/page_folders/#{inFolderWithId}/#{if folder then 'subfolders' else 'pages'}"
      method: 'POST'
      data:
        "#{if folder then 'page_folder' else 'page'}":
          title: title

    p.done ->
      swal.close()
      Turbolinks.visit window.location.href, action: 'replace'

    p.fail (e) ->
      console.log e
      swal
        title: I18n.t 'error'
        text: I18n.t "create_#{if folder then 'folder' else 'page'}_fail"
        type: 'error'


$(document).on 'click', '#create-page-button', ->
  create(folder: false, inFolderWithId: $(@).data('folder'))

$(document).on 'click', '#create-page-folder-button', ->
  create(folder: true, inFolderWithId: $(@).data('folder'))

$(document).on 'click', '#goto-page-search-button', ->
  Turbolinks.visit '/page_search'

