# Service takes an ip or url as a parameter, then sends a request to the API which returns geolocation for the ip.
# When service receives geolocation data, it stores this information in the database.

class IpGeolocationService
  def initialize(geolocation_api = IpGeolocationAdapter.new)
    @geolocation_api = geolocation_api
  end

  # Starts processing provided ip or url. If the ip/url is already
  # present in the database it's data is going to be updated.
  # If it's not present a new IpInfo object will be created in the database.
  #
  # @param ip [String] ip address
  # @param url [String] url of a website
  # @return [IpInfo] object of the IpInfo class, either newly created or updated
  def call(ip: nil, url: nil)
    ip_or_url = ip.presence || url

    geolocation_data = @geolocation_api.ip_geolocation(ip_or_url)
    build_ip_data(url, geolocation_data)

    # One url can have many ips, case of a loadbalancer
    ip_obj = load_ip_object(url, geolocation_data)

    update_or_create_ip(ip_obj, geolocation_data)
  end

  private

  def load_ip_object(url, geolocation_data)
    # If url is present, it means that golocation API returned some ip for it.
    if url.present?
      IpInfo.where(
        ip: geolocation_data[:ip],
        url: geolocation_data[:url]
      ).first
    else
      # If url is not present find IpInfo based only on IP
      IpInfo.find_by(ip: geolocation_data[:ip])
    end
  end

  def build_ip_data(url, geolocation_data)
    geolocation_data[:url] = url if url.present?
  end

  def update_or_create_ip(ip_obj, data_to_save)
    if ip_obj.present?
      ip_obj.touch
      ip_obj.update!(data_to_save)
      return ip_obj
    end

    IpInfo.create!(data_to_save)
  end
end
