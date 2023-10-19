class IpInfo < ApplicationRecord
  enum type: %i[ipv4 ipv6]
end
