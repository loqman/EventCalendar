class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy, :share]
  before_action :set_user_id, only: [:create, :update, :destroy]

  def index

  end

  def get_events
    start_date = DateTime.parse params[:start_date]
    end_date = DateTime.parse params[:end_date]
    @events = current_user.events.where(start_date: start_date..end_date)
    respond_to do |format|
      format.json
    end
  end

  def show
    user_ids = @event.users.map { |u| u.id.to_s }
    @users = User.not_in(id: user_ids)
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
        @event.users.each do |user|
          user_id = user.id.to_s
          ActionCable.server.broadcast "user_#{user_id}_channel", type: 'eventUpdated', event: @event
        end
        format.json { render :show, status: :created, location: @event }
      else
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.users.each do |user|
      user_id = user.id.to_s
      ActionCable.server.broadcast "user_#{user_id}_channel", type: 'eventDestroyed', eventId: @event.id.to_s
    end
    @event.destroy
    respond_to do |format|
      format.json { render json: {eventId: @event.id.to_s}, status: :ok }
    end
  end

  def share
    audience = params[:event][:audience]
    @target_user = User.find audience
    @event.users.push @target_user
    respond_to do |format|
      if @event.save
        ActionCable.server.broadcast "user_#{audience}_channel", type: 'eventShared', event: @event
        format.json { render json: {success: true}, status: :ok }
      else
        format.json { render json: {success: false}, status: :unprocessable_entity }
      end
    end
  end

  def icalendar
    if params[:start_date].nil?
      events = current_user.events
    else
      start_date = DateTime.parse params[:start_date]
      end_date = DateTime.parse params[:end_date]
      events = current_user.events.where(start_date: start_date..end_date)
    end
    ical = Icalendar::Calendar.new
    events.each do |event|
      ical.event do |e|
        e.dtstart = Icalendar::Values::DateTime.new(event.start_date)
        e.dtend = Icalendar::Values::DateTime.new(event.end_date)
        e.summary = event.title.to_farsi
        e.description = event.description.to_farsi
      end
    end
    ical_output = ical.to_ical
    send_data ical_output, filename: "#{current_user.email}_#{Date.today.to_s.gsub(/\s+/, '-')}.ics"
  end

  def gcal
    calendar_id = 'primary'
    # Create an instance of the calendar.
    calendar = Google::Calendar.new(:client_id => @@google_app_id,
                                    :client_secret => @@google_app_secret,
                                    :calendar => calendar_id,
                                    :redirect_url => "urn:ietf:wg:oauth:2.0:oob") # this is what Google uses for 'applications'

    calendar.login_with_refresh_token(current_user.omniauth_refresh_token)
    g_events = calendar.events
    g_events.each do |event|
      start_time = DateTime.parse event.start_time
      end_time = DateTime.parse event.end_time
      start_time_jalali = JalaliDate.new(start_time).to_s.gsub('/', '-') + ' ' + start_time.strftime('%I:%M:%S %p')
      end_time_jalali = JalaliDate.new(end_time).to_s.gsub('/', '-') + ' ' + end_time.strftime('%I:%M:%S %p')
      event_data = {id: event.id,
                    g_html_link: event.html_link,
                    g_author: event.creator_name,
                    start_date: event.start_time,
                    end_date: event.end_time,
                    start_date_jalali: start_time_jalali,
                    end_date_jalali: end_time_jalali,
                    title: event.title,
                    description: event.raw['description'],
                    from_google: true,
                    g_synced: true, color: '#db4437'}
      current_user.events.create! event_data
    end
    redirect_to root_path
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
