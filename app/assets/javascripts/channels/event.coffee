$(document).on 'turbolinks:load', ->
  user_id = $('body').data('user-id')

  App.event = App.cable.subscriptions.create {
    channel: "EventChannel"
    userId: user_id
    },
    connected: ->
      # Called when the subscription is ready for use on the server
      console.log 'WebSocket connected!'


    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      # Called when there's incoming data on the websocket for this channel
      console.log data
      if data['type'] == 'eventCreated'
        console.log 'EventCreated'
        eventData =
          title: data['event']['title']
          start: data['event']['start_date']
          end: data['event']['end_date']
        console.log eventData
        $('.calendar').fullCalendar('renderEvent', eventData, true)

    share: ->
      @perform 'share'
