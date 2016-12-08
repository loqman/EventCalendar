# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class EventChannel < ApplicationCable::Channel
  def subscribed
    channel = "user_#{params[:userId]}_channel"
    stream_from channel
    ActionCable.server.broadcast channel, type: 'eventCreated', event: Event.last
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def share
  end
end
