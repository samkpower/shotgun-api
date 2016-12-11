class V1::ApiController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format.json? }
  respond_to :json

  after_action :set_headers

  def preflight_check
    render json: :ok
  end

  private

  def set_headers
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Headers'] = 'Content-Type'
    response.headers['Content-Type'] = 'application/json'
  end

  def errors_json_api_format(errors)
    return errors.map do |attribute, message|
      { detail: message, source: { pointer: "data/attributes/#{attribute}" } }
    end
  end
end
