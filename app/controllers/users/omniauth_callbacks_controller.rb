module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    respond_to :json, :html

    def google_oauth2
      @user = User.from_omniauth(request.env['omniauth.auth'])
      if @user.persisted?
        respond_to do |format|
          # TODO: remove this
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
  end
end
