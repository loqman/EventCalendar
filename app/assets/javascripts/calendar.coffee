# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  new_event_path = $('.event-block').data('new-event');
  console.log new_event_path
  $.get new_event_path, (data) ->
    console.log data
    $('.event-block').append $(data)

  calendar_select = (start, end_date) ->
    #console.log start, end
    # title = prompt('Event Title:');
    $('#event_start_date').val start
    $('#event_start_date').pDatepicker
      persianDigit: true
      timePicker:
        enabled: true
    $('#event_end_date').val end_date
    $('#event_end_date').pDatepicker()
    eventData = {}
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
    defaultDate: '2016-09-12'
    editable: true
    selectable: true
    selectHelper: true
    select: calendar_select
    eventLimit: true
    isJalaali: true
    isRTL: true
    lang: 'fa'
    timezone: 'local'
