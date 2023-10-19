# This class will handle a response received from the ip geolocation API.
# If the API response is no successful, the error will be raised
class IpGeolocationResponseHandler
  class IpGeolocationError < StandardError; end

  # Raises IpGeolocationError when Geolocation service response is invalid.
  # The error can be rescued and handled by the higher level code.
  #
  # @param response [Hash] geolocation service response.
  def self.handle_response(response)
    # To cover the case when url with https is provided
    raise IpGeolocationError.new, 'Not Found' if response['detail'] == 'Not Found'
    raise IpGeolocationError.new, response.dig('error', 'info') if response['success'] == false
  end
end
