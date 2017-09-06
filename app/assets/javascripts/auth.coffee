# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready( ->
  handleDatePickers = ->
    if jQuery().datepicker
      $('.date-picker').datepicker {
        autoclose: true
      }
    return;

  handleDatePickers()

  $('.registration-form .submit').click (e) ->
    e.preventDefault()
    incorrect = false
    $('.remote').hide()
    $('.text-required').each ->
      parent = $(this).parents('.form-group')
      if $(this).val() == ''
        incorrect = true
        parent.addClass('require')
        return
      else
        parent.removeClass('require')
        return

    email_tester = /^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i
    if (!email_tester.test($('#user_email').val()) && $('#user_email').val() != '')
      alert(!email_tester.test($('#user_email').val()))
      incorrect = true
      $('#user_email').parents('.form-group').addClass('validate-error')
    else
      $('#user_email').parents('.form-group').removeClass('validate-error')
    if $('.password').val() != $('.password_confirmation').val()
      incorrect = true
      $('.password_confirmation').parent().addClass('confirmation')
    else
      $('.password_confirmation').parent().removeClass('confirmation')

    if !incorrect
      $('.registration-form').submit()
      return

  $('.login-form .submit').click (e) ->
    e.preventDefault()
    incorrect = false
    $('.remote').hide()
    $('.text-required').each ->
      parent = $(this).parents('.form-group')
      if $(this).val() == ''
        incorrect = true
        parent.addClass('require')
        return
      else
        parent.removeClass('require')
        return

    if !incorrect
      $('.login-form').submit()
      return
  return
)