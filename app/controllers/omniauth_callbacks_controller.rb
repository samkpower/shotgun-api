class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  respond_to :json

  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      if request.format.json?
        data = {
          id: @user.id,
          token: @user.authentication_token,
          email: @user.email
        }
        render json: data, status: 201
      end
    end
  end
end
