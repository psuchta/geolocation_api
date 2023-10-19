# Adapter can be handy in the future if a need for change geolocation provider happens.
# It will help adapt api responses into one standardized hash.

class IpGeolocationAdapter
  # Sends the ip address to an external API service, the service returns geolocation data
  #
  # @param ip_or_url [String] ip address or url of a website
  # @return [Hash] geolocation information
  def ip_geolocation(ip_or_url)
    api_response = Ipstack::API.standard(ip_or_url)
    IpGeolocationResponseHandler.handle_response(api_response)

    result = shape_geo_result(api_response)
    result.merge!(append_additional_info(api_response))
    result
  end

  private

  # Creates standardized hash with geolocation data, provided by the external API.
  #
  # @param ip_info [Hash] nonstandardized geolocation information
  # @return [Hash] standardized geolocation hash
  def shape_geo_result(ip_info)
    {
      continent_name: ip_info['continent_name'],
      country_name: ip_info['country_name'],
      region_name: ip_info['region_name'],
      city: ip_info['city'],
      zip: ip_info['zip'],
      latitude: ip_info['latitude'],
      longitude: ip_info['longitude']
    }
  end

  # Returns additional ip info in standardized hash.
  #
  # @param ip_info [Hash] nonstandardized geolocation information
  # @return [Hash] standardized additional ip info hash
  def append_additional_info(ip_info)
    {
      ip: ip_info['ip'],
      type: ip_info['type']
    }
  end
end
