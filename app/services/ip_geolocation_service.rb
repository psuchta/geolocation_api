class IpGeolocationService
  def initialize(geolocation_api = IpGeolocationAdapter.new)
    @geolocation_api = geolocation_api
  end

  def call(ip: nil, url: nil)
    ip_or_url = ip.presence || url

    geolocation_data = @geolocation_api.ip_geolocation(ip_or_url)
    build_ip_data(url, geolocation_data)

    # One url can have many ips, case of loadbalancer
    ip_obj = if url.present?
               IpInfo.where(
                 ip: geolocation_data[:ip],
                 url: geolocation_data[:url]
               ).first
             else
               IpInfo.find_by_ip_or_url(ip_or_url)
             end

    update_or_create_ip(ip_obj, geolocation_data)
  end

  def build_ip_data(url, geolocation_data)
    geolocation_data[:url] = url if url.present?
  end

  def update_or_create_ip(ip_obj, save_data)
    if ip_obj.present?
      ip_obj.touch
      ip_obj.update!(save_data)
      return ip_obj
    end

    IpInfo.create!(save_data)
  end
end
