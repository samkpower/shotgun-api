class ApplicationController < ActionController::Base

  private

  def authenticate_api_request!
    authenticate_user_from_token!
    authenticate_user!
  end

  def authenticate_user_from_token!
    user_email = request.headers['HTTP_REQUESTOR_EMAIL'].presence
    user = user_email && User.find_by(email: user_email)
    auth_token = request.headers['HTTP_AUTHORIZATION_TOKEN']

    return false unless user && auth_token.present?

    if user && Devise.secure_compare(user.authentication_token, auth_token)
      sign_in user, store: false
    end
  end
end
