# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready( ->
  handlePanelSortable = ->
    if !jQuery().sortable
      return;
    $('#sortable_panels').sortable {
      opacity: 0.8,
      coneHelperSize: true,
      placeholder: 'sortable-box-placeholder panel visible',
      forcePlaceholderSize: true,
      tolerance: "pointer",
      stop: ->
        panel_options = []
        $('.panel').each ->
          panel_type = $(this).data('type')
          isVisible = $(this).hasClass('visible')
          panel_options.push {panel_type: panel_type, is_visible: isVisible}
          return

        $.post('/project/setPanelOptions',
          {
            panel_options: JSON.stringify(panel_options)
          }
        )
        return
    }
    return

  handlePanels = ->
    $(document).on('click', '.panel-toggle', ->
      parent = $(this).parents('.item');
      type = $(this).data('panel-type');
      isVisible = parent.hasClass('visible');
      if isVisible
        return false;
      else
        parent.addClass('visible');
        $('.panel.'+type).addClass('visible');
      return;
    )
    $(document).on('click', '.panel .close', ->
      parent = $(this).parents('.panel');
      parent.removeClass('visible');
      type = parent.data('type');
      $('.item.'+type).removeClass('visible');
    )
    return;

  handlePanelSortable()
  handlePanels()

  handleHold = (collpase_key, items) ->
    header = items.find('.items-header');
    content = items.find('.items-content');
    icon = header.find('.story-collapse i');

    if collpase_key == 'expand'
      content.slideDown()
      if !content.hasClass('expand')
        content.addClass('expand')
      icon.removeClass('fa-plus');
      icon.addClass('fa-minus');
      header.find('.story-info-section').fadeOut();
    else
      content.slideUp()
      if content.hasClass('expand')
        content.removeClass('expand')
      icon.removeClass('fa-minus');
      icon.addClass('fa-plus');
      header.find('.story-info-section').fadeIn();
    return;

  $(document).on 'click', '.story-collapse', ->
    parent = $(this).parents('.items');
    content = parent.find('.items-content');

    if content.hasClass('expand')
      handleHold('collapse', parent);
    else
      handleHold('expand', parent);
    return;

  $(document).on 'click', '.expand-all', ->
    panel = $(this).parents('.panel');
    container = panel.find('.items-container');
    container.find('.items').each ->
      handleHold 'expand', $(this);
      return;
    return;
  $(document).on 'click', '.collapse-all', ->
    panel = $(this).parents('.panel');
    container = panel.find('.items-container');
    container.find('.items').each ->
      handleHold 'collapse', $(this);
      return;
    return;

  $('.story-create-form .submit').click (e) ->
    e.preventDefault()

    incorrect = false
    story_create_form = $('.story-create-form');
    story_create_form.find('.text-required').each ->
      parent = $(this).parents('.form-group');
      if $(this).val() == ''
        console.log($(this));
        incorrect = true;
        parent.addClass('require');
        return
      else
        parent.removeClass('require')
        return

    if !incorrect
      story_create_form.submit();
      story_create_form.find('#story_members').val('');
      return;

  $(document).on 'click', '.btn-edit', (e) ->
    e.preventDefault()
    parent = $(this).parent()
    parent.addClass('edit');
    form = $(this).parents('form')
    form.find('.text-required').removeAttr('readonly')
    return;

  $(document).on 'click', '.btn-cancel', (e) ->
    e.preventDefault()
    parent = $(this).parent();
    form_parent = $(this).parents('form');
    original_value = form_parent.find('.original-value').val();
    form_parent.find('.text-required').val(original_value)
    parent.removeClass('edit');
    form_parent.find('.text-required').attr('readonly', 'readonly')
    return;

  $(document).on 'click', '.btn-submit', (e) ->
    e.preventDefault();
    incorrect = false
    form_parent = $(this).parents('form');
    form_parent.find('.text-required').each ->
      if $(this).val() == ''
        incorrect = true;
      else
        incorrect = false;
      return;

    if !incorrect
      form_parent.removeClass('require');
      form_parent.submit();
      form_parent.find('.text-required').attr('readonly', 'readonly')
    else
      form_parent.addClass('require');
    return;

  $(document).on 'change', '.auto-save', ->
    parent_form = $(this).parents('.update-story-form')
    parent_form.submit()

  return;
)