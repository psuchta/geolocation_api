class ApplicationController < ActionController::API

  rescue_from ActiveRecord::RecordNotFound do
    render json: { message: "Requested Ip cannot be found in the database" },
           status: :not_found
  end
end
