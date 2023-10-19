require 'rails_helper'

RSpec.describe IpInfo, type: :model do
  describe '.create' do
    it 'creates a new object' do
      create(:ip_info, city: 'Warsaw')
      expect(IpInfo.where(city: 'Warsaw').count).to eq(1)
    end

    it 'create a new object based on hash' do
      attributes = {
        ip: '8.8.8.8',
        ip_type: 'ipv4',
        continent_name: 'North America',
        country_name: 'United States',
        region_name: 'Ohio',
        city: 'Glenmont',
        zip: '44628',
        latitude: 40.5369987487793,
        longitude: -82.12859344482422
      }

      expect { IpInfo.create!(attributes) }.to change { IpInfo.count }
      last = IpInfo.last
      expect(last.ip).to eq('8.8.8.8')
      expect(last.ip_type).to eq('ipv4')
    end
  end
end
