class CalendarController < ApplicationController
  before_action :authenticate_user!
  layout 'calendar'

  def index
  end
end
