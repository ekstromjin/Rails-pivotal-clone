# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready( ->
  $('.comment-create-form .submit').click (e) ->
    e.preventDefault()
    incorrect = false
    parent = $(this).parent()
    if parent.find('#comment_comment').val() == ''
      incorrect = true;
    if (incorrect)
      parent.addClass('require')
    else
      parent.submit()
      parent.removeClass('require')
    return;
  return;
)