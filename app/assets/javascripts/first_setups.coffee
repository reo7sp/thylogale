# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

import_choices_ids = ['#first_setup_import_choice_new', '#first_setup_import_choice_upload']
save_choices_ids = ['#first_setup_save_choice_local', '#first_setup_save_choice_s3']
email_choices_ids = ['#first_setup_email_choice_local', '#first_setup_email_choice_mailgun']
controls_ids = ['#first_setup_import_file', '#first_setup_save_s3_access_key', '#first_setup_save_s3_secret',  '#first_setup_save_s3_region', '#first_setup_email_mailgun_api_key', '#first_setup_email_mailgun_domain', '#first_setup_admin_password', '#first_setup_admin_email']

emailRegex = /^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i


is_checked = (selector) -> $(selector).prop('checked')

has_files = (selector) -> $(selector).get(0).files.length > 0

has_text = (selector) -> $(selector).val().length > 0

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
    if not has_text(controls_ids[6]) or not has_text(controls_ids[7]) or not is_valid_email(controls_ids[7])
      ok = false

  $('#first_setup_finish_btn').attr('disabled', !ok)
  
  return
  
init = ->
  for ids in [import_choices_ids, save_choices_ids, email_choices_ids]
    for id in ids
      do (id, ids) ->
        $(document.body).on 'change', id, (e) ->
          for id2 in ids
            if id2 == id
              $("#{id2}_details").removeClass('hidden')
            else
              $("#{id2}_details").addClass('hidden')
              
          check_form()
          
          return

  for id in controls_ids
    $(document.body).on 'input change', id, (e) ->
      check_form()
      return

  return
  
is_setup_page = -> $(document.body).attr('data-controller') == 'first_setups'

  
if is_setup_page
  init()
