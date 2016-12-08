# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  new_event_path = $('.event-block').data('new-event');
  console.log new_event_path
  $.get new_event_path, (data) ->
    $('.event-block').append $(data)
    $("#event_color").paletteColorPicker()

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

  moment.tz.add('Asia/Tehran|IRST IRDT|-3u -4u|01010101010101010101010|1BTUu 1dz0 1cp0 1dz0 1cp0 1dz0 1cN0 1dz0 1cp0 1dz0 1cp0 1dz0 1cp0 1dz0 1cN0 1dz0 1cp0 1dz0 1cp0 1dz0 1cp0 1dz0|14e6')
  moment.tz.add('Etc/UTC|UTC|0|0|')


undefined