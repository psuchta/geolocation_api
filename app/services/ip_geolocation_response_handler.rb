# This class will handle a response received from the ip geolocation API.
# If the API response is no successful, the error will be raised
class IpGeolocationResponseHandler
  class GeolocationResponseError < StandardError; end
  class GeolocationApiDownError < GeolocationResponseError; end

  # Raises GeolocationResponseError when Geolocation service response is invalid.
  # The error can be rescued and handled by the higher level code.
  #
  # @param response [Hash] geolocation service response.
  def self.handle_response(response)
    # To cover the case when url with https is provided
    raise GeolocationResponseError.new, 'Not Found' if response['detail'] == 'Not Found'
    raise GeolocationResponseError.new, response.dig('error', 'info') if response['success'] == false
  end

  def self.handle_api_down
    yield
  rescue SocketError
    raise GeolocationApiDownError.new, 'Geolocation provider is not responding'
  end
end
