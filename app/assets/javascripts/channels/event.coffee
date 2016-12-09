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
        eventId = data['event']['_id']['$oid']
        if $("#event_#{eventId}").length == 0
          eventData =
            id: data['event']['_id']['$oid']
            title: data['event']['title']
            start: data['event']['start_date']
            end: data['event']['end_date']
            color: data['event']['color']
          console.log eventData
          $('.calendar').fullCalendar('renderEvent', eventData)
        else
          console.log 'Event already in the grid'

      else if data['type'] == 'eventUpdated'
        console.log 'EventUpdated'
        eventId = data['event']['_id']['$oid']
        elementId = "#event_#{eventId}"
        $('.calendar').fullCalendar('removeEvents', eventId)
        eventData =
          id: data['event']['_id']['$oid']
          title: data['event']['title']
          start: data['event']['start_date']
          end: data['event']['end_date']
          color: data['event']['color']
        console.log eventData
        $('.calendar').fullCalendar('renderEvent', eventData)

      else if data['type'] == 'eventDestroyed'
        console.log 'EventDestroyed'
        $('.calendar').fullCalendar('removeEvents', data['eventId'])

      else if data['type'] == 'eventShared'
        console.log 'EventShared'
        eventId = data['event']['_id']['$oid']
        if $("#event_#{eventId}").length == 0
          eventData =
            id: data['event']['_id']['$oid']
            title: data['event']['title']
            start: data['event']['start_date']
            end: data['event']['end_date']
            color: data['event']['color']
          console.log eventData
          $('.calendar').fullCalendar('renderEvent', eventData)
        else
          console.log 'Event already in the grid'



    share: ->
      @perform 'share'
