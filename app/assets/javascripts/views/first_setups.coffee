import_choices_ids = ['#first_setup_import_choice_new', '#first_setup_import_choice_upload']
save_choices_ids = ['#first_setup_save_choice_local', '#first_setup_save_choice_s3']
email_choices_ids = ['#first_setup_email_choice_local', '#first_setup_email_choice_mailgun']
controls_ids = ['#first_setup_import_file', '#first_setup_save_s3_access_key', '#first_setup_save_s3_secret',  '#first_setup_save_s3_region', '#first_setup_email_mailgun_api_key', '#first_setup_email_mailgun_domain', '#admin_user_password', '#admin_user_password_confirmation', '#admin_user_email']

emailRegex = /^[^@]+@([^@\.]+\.)+[^@\.]+$/


is_checked = (selector) -> $(selector).prop('checked')

has_files = (selector) -> $(selector).get(0).files.length > 0

has_text = (selector) -> $(selector).val().length > 0
  
text_equals = (selector1, selector2) -> $(selector1).val() == $(selector2).val()

is_valid_email = (selector) -> emailRegex.test($(selector).val())

check_form = ->
  ok = true

  # import
  if is_checked(import_choices_ids[1])
    if not has_files(controls_ids[0])
      ok = false

  # save
  if ok and is_checked(save_choices_ids[1])
    if not has_text(controls_ids[1]) or
        not has_text(controls_ids[2]) or
        not has_text(controls_ids[3])
      ok = false

  # email
  if ok and is_checked(email_choices_ids[1])
    if not has_text(controls_ids[4]) or
        not has_text(controls_ids[5])
      ok = false

  # admin user
  if ok
    if not has_text(controls_ids[6]) or 
        not text_equals(controls_ids[6], controls_ids[7]) or
        not has_text(controls_ids[8]) or 
        not is_valid_email(controls_ids[8])
      ok = false

  $('#first_setup_finish_btn').attr('disabled', !ok)
  
init = ->
  for ids in [import_choices_ids, save_choices_ids, email_choices_ids]
    for id in ids
      do (id, ids) ->
        $(id).on 'change', (e) ->
          for id2 in ids 
            $("#{id2}_details").toggleClass('hidden', id2 == id)
          check_form()

  for id in controls_ids
    $(id).on 'input change', (e) ->
      check_form()

  return
  
is_setup_page = -> $(document.body).attr('data-controller') == 'first_setups'

  
init() if is_setup_page
