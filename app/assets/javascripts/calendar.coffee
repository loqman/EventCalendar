# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  new_event_path = $('.event-block').data('new-event');
  console.log new_event_path

  # loading event informatio remotely
  window.load_event_information = (eventId) ->
    $.get "/events/#{eventId}", (data) ->
      $('.event-block').empty()
      $('.event-block').append $(data)

  # loading new evet form remotely
  window.load_new_event_panel = ->
    $.get new_event_path, (data) ->
      $('.event-block').empty()
      $('.event-block').append $(data)
      window.load_color_palette()
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

    # loading edit event form remotely
    window.load_edit_event_panel = (path, eventId) ->
      $.get path, (data) ->
        $('.event-block').empty()
        $('.event-block').append $(data)
        window.load_color_palette()
        # Ajax form handling for event
        $('.edit_event').on("ajax:success", (e, data, status, xhr) ->
          $('.edit_event .help-text').detach()
          console.log xhr.responseText
          window.load_event_information(eventId)
        ).on("ajax:error", (e, xhr, status, error) ->
          $('.edit_event .help-text').detach()
          console.log xhr.responseText
          response = $.parseJSON(xhr.responseText)
          Object.keys(response).forEach (field) ->
            field_id = "#event_#{field}"
            for err in response[field]
              node = $("<span class='help-text'>#{err}</span>")
              node.insertAfter(field_id)
        )

    # Color swatch
    window.load_color_palette = ->
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

  $('.event-block').on 'click', '#delete_event', (event) ->
    console.log 'here'
    event.preventDefault()

  after_event_rendered = (event, element, view) ->
    $(element).attr('data-event-id', event.id)
    $(element).attr('id', "event_#{event.id}")
    $(element).click ->
      eventId = $(element).data('event-id')
      window.load_event_information(eventId)


  calendar_select = (start_date, end_date) ->
    $('#event_start_date_jalali').val start_date
    $('#event_start_date_jalali').pDatepicker
      persianDigit: true
      altField: '#event_start_date'
      altFormat: 'g'
      timePicker:
        enabled: true
    $('#event_end_date_jalali').val end_date
    $('#event_end_date_jalali').pDatepicker
      altField: '#event_end_date'
      altFormat: 'g'
      timePicker:
        enabled: true

  $('.calendar').fullCalendar
    header:
      left: 'next,prev today'
      center: 'title'
      right: 'month,agendaWeek,agendaDay'
    defaultDate: moment.now()
    editable: false
    selectable: true
    selectHelper: true
    select: calendar_select
    eventAfterRender: after_event_rendered
    eventLimit: true
    isJalaali: true
    isRTL: true
    lang: 'fa'
    timezone: 'local'

  load_new_event_panel()




