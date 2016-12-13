class V1::UsersController < V1::ApiController
  before_filter :authenticate_api_request!, except: [:create]

  def index
    respond_with User.all
  end

  def show
    respond_with User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: 201, location: v1_user_url(@user)
    else
      render json: { errors: errors_json_api_format(@user.errors) }, status: 422
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      render json: @user, status: 200, location: v1_user_url(@user)
    else
      render json: { errors: errors_json_api_format(@user.errors) }, status: 422
    end
  end

  private

  def user_params
    params.permit(:email, :first_name, :password, :password_confirmation)
  end
end
