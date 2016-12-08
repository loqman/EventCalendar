# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  new_event_path = $('.event-block').data('new-event');
  console.log new_event_path
  $.get new_event_path, (data) ->
    $('.event-block').append $(data)
    # Ajax form handling for event
    $('.new_event').on("ajax:success", (e, data, status, xhr) ->
      $('.new_event .help-text').detach()
      console.log xhr.responseText
    ).on("ajax:error", (e, xhr, status, error) ->
      $('.new_event .help-text').detach()
      console.log xhr.responseText
      response = $.parseJSON(xhr.responseText)
      Object.keys(response).forEach (field) ->
        field_id = "#event_#{field}"
        for err in response[field]
          node = $("<span class='help-text'>#{err}</span>")
          node.insertAfter(field_id)
    )
    # Color swatch
    $("#event_color").paletteColorPicker
      colors: [
        {"#D20000": "#D20000"}
        {"#304FFE": "#304FFE"}
        {"#00B8D4": "#00B8D4"}
        {"#00C853": "#00C853"}
        {"#FFD600": "#FFD600"}
        {"#FF6D00": "#FF6D00"}
        {"#FF1744": "#FF1744"}
        {"#3D5AFE": "#3D5AFE"}
        {"#00E5FF": "#00E5FF"}
        {"#00E676": "#00E676"}
        {"#FFEA00": "#FFEA00"}
        {"#FF9100": "#FF9100"}
        {"#FF5252": "#FF5252"}
        {"#536DFE": "#536DFE"}
        {"#18FFFF": "#18FFFF"}
        {"#69F0AE": "#69F0AE"}
        {"#FFFF00": "#FFFF00"}
        {"#FFAB40": "#FFAB40"}
      ]
      clear_btn: null

  calendar_select = (start_date, end_date) ->
#console.log start, end
# title = prompt('Event Title:');
    $('#event_start_date').val start_date
    $('#event_start_date').pDatepicker
      persianDigit: true
      timePicker:
        enabled: true
    $('#event_end_date').val end_date
    $('#event_end_date').pDatepicker()
    eventData = {}
    window.date_time = start_date
    if (title)
      eventData =
        title: title
        start: start
        end: end_date
      $('.calendar').fullCalendar('renderEvent', eventData, true)
  #$('.calendar').fullCalendar('unselect')


  $('.calendar').fullCalendar
    header:
      left: 'next,prev today'
      center: 'title'
      right: 'month,agendaWeek,agendaDay'
    defaultDate: moment.now()
    editable: true
    selectable: true
    selectHelper: true
    select: calendar_select
    eventLimit: true
    isJalaali: true
    isRTL: true
    lang: 'fa'
    timezone: 'local'


