class GoogleEventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @google_events = User.last.get_gcal_events
    render json: @google_events
  end
end
