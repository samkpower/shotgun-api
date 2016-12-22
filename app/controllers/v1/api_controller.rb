class V1::ApiController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format.json? }
  respond_to :json

  private

  def errors_json_api_format(errors)
    return errors.map do |attribute, message|
      { detail: message, source: { pointer: "data/attributes/#{attribute}" } }
    end
  end
end
