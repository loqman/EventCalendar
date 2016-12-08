class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index

  end

  def show

  end

  def new
    @event = current_user.events.new
    render layout: false
  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy

  end

  def share

  end

  private
  def event_params
    params.require('event').permit!
  end

  def set_event
    @event = Event.find params[:id]
  end

end
