# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready( ->
  $(document).on 'change', '.task-status', ->
    parent = $(this).parents('tr');
    task_id = parent.data('task-id');
    status = 0;
    if $(this).is(':checked')
      status = 1
    $.post('/task/change_status', {task_id: task_id, status: status},
    ->
      return;
    );
    return;
  $('.task-create-form .submit').click (e) ->
    e.preventDefault()
    incorrect = false
    parent = $(this).parent()
    if parent.find('#task_title').val() == ''
      incorrect = true;
    if (incorrect)
      parent.addClass('require')
    else
      parent.submit()
      parent.removeClass('require')
    return;
  return;
)