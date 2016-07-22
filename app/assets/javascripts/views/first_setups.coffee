importChoicesIds = ['#first_setup_import_choice_new', '#first_setup_import_choice_upload']
saveChoicesIds = ['#first_setup_save_choice_local', '#first_setup_save_choice_s3']
emailChoicesIds = ['#first_setup_email_choice_local', '#first_setup_email_choice_mailgun']
controlsIds = ['#first_setup_import_file', '#first_setup_save_s3_access_key', '#first_setup_save_s3_secret',  '#first_setup_save_s3_region', '#first_setup_email_mailgun_api_key', '#first_setup_email_mailgun_domain', '#admin_user_password', '#admin_user_password_confirmation', '#admin_user_email']

emailRegex = /^[^@]+@([^@\.]+\.)+[^@\.]+$/


isChecked = (selector) -> $(selector).prop('checked')

hasFiles = (selector) -> $(selector).get(0).files.length > 0

hasText = (selector) -> $(selector).val().length > 0
  
textEquals = (selector1, selector2) -> $(selector1).val() == $(selector2).val()

isValidEmail = (selector) -> emailRegex.test($(selector).val())

checkForm = ->
  ok = true

  # import
  if isChecked(importChoicesIds[1])
    if not hasFiles(controlsIds[0])
      ok = false

  # save
  if ok and isChecked(saveChoicesIds[1])
    if not hasText(controlsIds[1]) or
        not hasText(controlsIds[2]) or
        not hasText(controlsIds[3])
      ok = false

  # email
  if ok and isChecked(emailChoicesIds[1])
    if not hasText(controlsIds[4]) or
        not hasText(controlsIds[5])
      ok = false

  # admin user
  if ok
    if not hasText(controlsIds[6]) or 
        not textEquals(controlsIds[6], controlsIds[7]) or
        not hasText(controlsIds[8]) or 
        not isValidEmail(controlsIds[8])
      ok = false

  $('#first_setup_finish_btn').attr('disabled', !ok)
  
init = ->
  for ids in [importChoicesIds, saveChoicesIds, emailChoicesIds]
    for id in ids
      do (id, ids) ->
        $(id).on 'change', (e) ->
          for id2 in ids 
            $("#{id2}_details").toggleClass('hidden', id2 == id)
          checkForm()

  for id in controlsIds
    $(id).on 'input change', (e) ->
      checkForm()

  return
  
isSetup = -> $(document.body).data('controller') == 'first_setups'

  
init() if isSetup
