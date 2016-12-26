class V1::EventsController < V1::ApiController
  before_action :authenticate_api_request!

  def index
    if filter_params
      respond_with Event.where(filter_params)
    else
      respond_with Event.all
    end
  end

  def show
    respond_with Event.find(params[:id])
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      render json: @event, status: 201, location: v1_event_url(@event)
    else
      render json: { errors: errors_json_api_format(@event.errors) }, status: 422
    end
  end

  def update
    @event = Event.find(params[:id])

    if @event.update(event_params)
      render json: @event, status: 200, location: v1_event_url(@event)
    else
      render json: { errors: errors_json_api_format(@event.errors) }, status: 422
    end
  end

  def destroy
    @event = Event.find(params[:id])

    if @event.destroy
      render json: @event, status: 200, location: v1_event_url(@event)
    else
      render json: { errors: errors_json_api_format(@event.errors) }, status: 422
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :start, :end, :user_id)
  end

  def filter_params
    allowed_filters = params.permit(filter: [:user_id])
    return allowed_filters.fetch(:filter, nil)
  end
end
