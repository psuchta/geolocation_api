FactoryBot.define do
  factory :ip_info do
    ip { "MyString" }
    url { "MyString" }
    type { :ipv4 }
    continent_name { "Europe" }
    country_name { "Poland" }
    region_name { "Mazovia" }
    city { "Ostrów Mazowiecka" }
    zip { "07-300" }
    latitude { 52.80529022216797 }
    longitude { 21.8941707611084 }
  end
end
