class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :invalid

  rescue_from IpGeolocationResponseHandler::GeolocationResponseError do |exception|
    render json: { message: exception.message }, status: 500
  end

  private

  def invalid(invalid)
    render json: { message: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end

  def not_found
    render json: { message: "Requested resource cannot be found in the database" }, status: :not_found
  end
end
