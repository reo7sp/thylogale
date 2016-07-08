create = ({folder, inFolderWithId}) ->
  title = prompt I18n.t 'enter_new_page'
    .trim()
  name = title
    .replace /[.,\/#!$%\^&\*;:{}=\-_`~() ]/g, '-'
    .squeeze '-'
    .toLowerCase()

  url = "/page_folders/#{inFolderWithId}#{if folder then '' else '/pages'}"

  p = $.ajax
    url: url
    method: 'POST'
    async: false
    data:
      "#{if folder then 'page_folder' else 'page'}":
        title: title
        name: name

  p.done ->
    Turbolinks.visit window.location.href, action: "replace"

  p.fail (e) ->
    alert I18n.t 'create_page_fail'
    console.log e

init = ->
  $(document).on 'click', '#create-page-button', ->
    create folder: false, inFolderWithId: $(@).attr('data-in-folder')

  $(document).on 'click', '#create-page-folder-button', ->
    create folder: true, inFolderWithId: $(@).attr('data-in-folder')


init()