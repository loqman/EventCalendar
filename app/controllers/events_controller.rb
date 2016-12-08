class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_user_id, only: [:create, :update]

  def index

  end

  def get_events
    puts "=============="
    puts params.inspect
    start_date = DateTime.parse params[:start_date]
    end_date = DateTime.parse params[:end_date]
    @events = current_user.events.where(start_date: start_date..end_date)
    respond_to do |format|
      format.json
    end
  end

  def show
    respond_to do |format|
      format.html { render layout: false }
      format.json
    end
  end

  def new
    @event = current_user.events.new
    render layout: false
  end

  def create
    @event = current_user.events.new event_params
    @event.author_id = current_user.id.to_s
    respond_to do |format|
      if @event.save
        ActionCable.server.broadcast "user_#{@user_id}_channel", type: 'eventCreated', event: @event
        format.json { render :show, status: :created, location: @event }
      else
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    render layout: false
  end

  def update
    @event.edited_by_id = current_user.id.to_s
    respond_to do |format|
      if @event.update event_params
        ActionCable.server.broadcast "user_#{@user_id}_channel", type: 'eventUpdated', event: @event
        format.json { render :show, status: :created, location: @event }
      else
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.json { render json: { eventId: @event.id.to_s }, status: :ok }
    end
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

  def set_user_id
    @user_id = current_user.id.to_s
  end

end
