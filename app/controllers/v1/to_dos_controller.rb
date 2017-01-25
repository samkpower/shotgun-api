class V1::ToDosController < V1::ApiController
  before_action :authenticate_api_request!

  def index
    if filter_params
      respond_with ToDo.where(filter_params)
    else
      respond_with ToDo.all
    end
  end

  def show
    respond_with ToDo.find(params[:id])
  end

  def create
    @to_do = ToDo.new(to_do_params)

    if @to_do.save
      render json: @to_do, status: 201, location: v1_to_do_url(@to_do)
    else
      render json: { errors: errors_json_api_format(@to_do.errors) }, status: 422
    end
  end

  def update
    @to_do = ToDo.find(params[:id])

    if @to_do.update(to_do_params)
      render json: @to_do, status: 200, location: v1_to_do_url(@to_do)
    else
      render json: { errors: errors_json_api_format(@to_do.errors) }, status: 422
    end
  end

  def destroy
    @to_do = ToDo.find(params[:id])

    if @to_do.destroy
      render json: @to_do, status: 200, location: v1_to_do_url(@to_do)
    else
      render json: { errors: errors_json_api_format(@to_do.errors) }, status: 422
    end
  end

  private

  def to_do_params
    params.require(:to_do).permit(:name, :user_id, :complete)
  end

  def filter_params
    allowed_filters = params.permit(filter: [:user_id])
    return allowed_filters.fetch(:filter, nil)
  end
end
