# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  $('.calendar').fullCalendar
    defaultDate: '2016-09-12'
    editable: true
    eventLimit: true
    isJalaali: true
    isRTL: true
    lang: 'fa'