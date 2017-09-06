# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready( ->
  handleSidebarToggle = ->
    $(document).on 'click', '.toggle-sidebar', ->
      content_wrap = $(this).parents('.content-wrap')
      if content_wrap.hasClass('expanded')
        content_wrap.removeClass('expanded')
        content_wrap.addClass('collapsed')
      else
        content_wrap.removeClass('collapsed')
        content_wrap.addClass('expanded')
      return;
    return;

  handleSelect2 = ->
    $('#project_members').select2 {
      data: memberData,
      multiple: true
    }
  handleDatePickers = ->
    if jQuery().datepicker
      $('.date-picker').datepicker {
        autoclose: true
      }
      return;

  handleIndexSecuritySelect = ->
    $('.index-page #project_security').change ->
      if $(this).val() == '1'
        $('#project_members').val('');
        handleSelect2();
        $('.members').show();
      else
        $('#project_members').val('');
        $('.members').hide();
      return;

  handleSettingSecuritySelect = ->
    $('.settings-container #project_security').change ->
      form_parent = $(this).parents('.project-update-form')
      members_block = form_parent.find('.project-members-block')
      if $(this).val() == '1'
        handleSelect2();
        if !members_block.hasClass('security-private')
          members_block.addClass('security-private')
      else
        members_block.removeClass('security-private')
      return;

  handleSidebarToggle()
  handleDatePickers()
  handleIndexSecuritySelect()
  handleSettingSecuritySelect()

  $(document).on 'shown.bs.tab', '.tab_link_fields .analytics-link', ->
    chart.handleResize()

  $('.project-update-form .submit').click (e) ->
    e.preventDefault();
    update_form = $(this).parents('.project-update-form');
    incorrect = false;

    update_form.find('.text-required').each ->
      parent = $(this).parents('.project-block')
      if $(this).val() == ''
        incorrect = true
        parent.addClass('require')
        return
      else
        parent.removeClass('require')
        return
    if (update_form.find('#project_security').val() == '1' && update_form.find('#project_members').val() == '')
      incorrect = true;
      update_form.find('.project-members-block').addClass('require')
    else
      update_form.find('.project-members-block').removeClass('require')
    if (!incorrect)
      update_form.submit()
    return

  $('.project-create-form .submit').click (e) ->
    e.preventDefault();
    incorrect = false;
    form_parent = $(this).parents('.project-create-form');
    form_parent.find('.text-required').each ->
      parent = $(this).parents('.form-group');
      if $(this).val() == ''
        incorrect = true;
        parent.addClass('require');
        return
      else
        parent.removeClass('require')
        return
    if form_parent.find('#project_security').val() == '1' && form_parent.find('#project_members').val() == ''
      incorrect = true
      form_parent.find('.members').addClass('require');
    if !incorrect
      form_parent.submit();
      return;

  $(document).on 'click', '.start-award', ->
    menu = $(this).parents('.sidebar-menu')
    if menu.children().hasClass('active')
      return

    $.post '/story/set_award', {
      story_id: $(this).data('storyid')
    }
    return

  $(document).on 'click', '.evaluate-point', ->
    points_list = $(this).parents('.points-list');
    points_item = $(this).parent();
    if points_list.children().hasClass('active')
      return

    points_list.removeClass('allow');
    points_item.addClass('active');
    $.post '/award/create', {
      story_id: $(this).data('storyid'),
      points: $(this).data('points'),
    }
    return;

  $(document).on 'click', '.btn-estimate-points', ->
    form_group = $(this).parents('.form-group')
    if ($('#awards').find('#points').val() != '')
      $.post('/story/set_points', {story_id: $(this).data('storyid'), points: $('#points').val()});
      form_group.removeClass('require');
    else
      form_group.addClass('require');
    return;

  return;
)