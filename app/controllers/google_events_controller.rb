class GoogleEventsController < ApplicationController
  before_action :authenticate_user!, :require_gcal_authorization!

  def index
    @google_events = current_user.get_gcal_events
    render json: @google_events
  end

  private

  def require_gcal_authorization!
    return if current_user.google_calendar_authorization.present?
    redirect_to new_authorizations_path
  end
end
