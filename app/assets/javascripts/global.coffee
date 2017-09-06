$(document).ready( ->
  $('#edit_profile .submit').click (e) ->
    e.preventDefault()
    incorrect = false
    form_parent = $('#edit_profile').find('.update-profile-form');
    form_parent.find('.text-required').each ->
      parent = $(this).parents('.form-group')
      if $(this).val() == ''
        incorrect = true
        parent.addClass('require')
        return
      else
        parent.removeClass('require')
        return
    if form_parent.find('.password').val() != form_parent.find('.password_confirmation').val()
      incorrect = true
      form_parent.find('.password_confirmation').parent().addClass('confirmation')
    else
      form_parent.find('.password_confirmation').parent().removeClass('confirmation')

    if !incorrect
      form_parent.submit()
      return
  return
)