class V1::EventsController < V1::ApiController
  before_filter :authenticate_api_request!

  def index
    respond_with Event.all
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
    params.require(:event).permit(:name, :start, :end)
  end

end
