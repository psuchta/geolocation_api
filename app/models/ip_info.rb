class IpInfo < ApplicationRecord
  enum :ip_type, %i[ipv4 ipv6]
end
