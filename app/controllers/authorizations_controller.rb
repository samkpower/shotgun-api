class AuthorizationsController < ApplicationController
  before_action :authenticate_user!

  def new
    # create a google calendar authorization
    user_id = current_user.uid
    credentials = authorizer.get_credentials(user_id, request)

    if credentials.nil?
      redirect_to authorizer.get_authorization_url(login_hint: user_id, request: request)
    else
      redirect_to root_path
    end
  end

  def callbacks
    user_id = current_user.uid
    current_user.guarantee_gcal_authorization!
    authorizer.handle_auth_callback(user_id, request)
    redirect_to root_url
  end

  private

  def authorizer
    @authorizer ||= Google::Auth::WebUserAuthorizer.new(
      GOOGLE_CLIENT_ID,
      User::HasGoogleCalendar::GOOGLE_CALENDAR_READ_ONLY_SCOPE,
      User::HasGoogleCalendar::GcalendarTokenStore.new,
      User::HasGoogleCalendar::GOOGLE_CALENDAR_CALLBACK_URI
    )
  end
end
