require 'rails_helper'

RSpec.describe IpInfo, type: :model do
  describe '.create' do
    it 'creates new object' do
      create(:ip_info, city: 'Warsaw')
      expect(IpInfo.where(city: 'Warsaw').count).to eq(1)
    end
  end
end
