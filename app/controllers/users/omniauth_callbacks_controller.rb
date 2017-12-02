# TODO: Temporary HTML endpoints for testing
module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    respond_to :json, :html

    def google_oauth2
      @user = User.from_omniauth(omniauth_payload)

      if @user.persisted?
        find_or_create_google_authorization(@user)

        respond_to do |format|
          format.html do
            sign_in(@user, scope: :user)
            return redirect_to new_user_session_path
          end

          format.json do
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

    private

    def omniauth_payload
      request.env['omniauth.auth']
    end

    def find_or_create_google_authorization(user)
      return if user.authorizations.find_by(
        user_id: user.id,
        provider: omniauth_payload[:provider],
        refresh_token: omniauth_payload[:credentials][:refresh_token]
      )
      user.authorizations.create!(
        user_id: user.id,
        provider: omniauth_payload[:provider],
        refresh_token: omniauth_payload[:credentials][:refresh_token],
        access_token: omniauth_payload[:credentials].to_json,
        scopes: %w[profile email]
      )
    end
  end
end
