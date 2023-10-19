class IpInfo < ApplicationRecord
  enum :ip_type, %i[ipv4 ipv6]

  validates :ip, uniqueness: true, presence: true

  def self.find_by_ip_or_url(ip_or_url)
    return nil if ip_or_url.blank?

    IpInfo.where(ip: ip_or_url)
          .or(IpInfo.where(url: ip_or_url)).first
  end
end
