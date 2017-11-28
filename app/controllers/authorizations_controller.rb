class AuthorizationsController < ApplicationController
  def new
    # create a google calendar authorization
    target_url = 'http://localhost:3000/authorizations/callbacks'
    token_store = GoogleCalendarEventFetcher::RailsTokenStore.new
    authorizer = Google::Auth::WebUserAuthorizer.new(GOOGLE_CLIENT_ID, GoogleCalendarEventFetcher::SCOPE, token_store, target_url)
    user_id = User.last.uid

    credentials = authorizer.get_credentials(user_id, request)

    if credentials.nil?
      redirect_to authorizer.get_authorization_url(login_hint: user_id, request: request)
    else
      redirect_to authorizations_path
    end
  end

  def show
    render json: 'Authenticated'
  end

  def callbacks
    user_id = User.last.uid
    target_url = 'http://localhost:3000/authorizations/callbacks'
    token_store = GoogleCalendarEventFetcher::RailsTokenStore.new
    authorizer = Google::Auth::WebUserAuthorizer.new(GOOGLE_CLIENT_ID, GoogleCalendarEventFetcher::SCOPE, token_store, target_url)
    authorizer.handle_auth_callback(user_id, request)
    redirect_to target_url
  end
end
