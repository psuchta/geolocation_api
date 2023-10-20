require 'rails_helper'

RSpec.describe IpGeolocationService, type: :model do
  let(:service) { IpGeolocationService.new }

  describe '#call' do
    context 'passing Ip to service' do
      it 'creates a new IpInfo object with column assigned', :vcr do
        expected = {
          'city' => 'Shaw',
          'continent_name' => 'North America',
          'country_name' => 'United States',
          'ip' => '13.32.151.115',
          'ip_type' => 'ipv4',
          'latitude' => 38.90689849853515,
          'longitude' => -77.02839660644531,
          'region_name' => 'Washington',
          'url' => nil,
          'zip' => '20026'
        }

        expect { service.call(ip: '13.32.151.115') }
          .to change { IpInfo.count }.by(1)

        expect(IpInfo.last.attributes).to include(expected)
      end
    end

    context 'passing Url to service' do
      it 'creates a new IpInfo object with column assigned', :vcr do
        expected = {
          'city' => 'San Francisco',
          'continent_name' => 'North America',
          'country_name' => 'United States',
          'ip' => '140.82.113.4',
          'ip_type' => 'ipv4',
          'latitude' => 37.76784896850586,
          'longitude' => -122.3928604125976,
          'region_name' => 'California',
          'url' => 'github.com',
          'zip' => '94107'
        }

        expect { service.call(url: 'github.com') }
          .to change { IpInfo.count }.by(1)

        expect(IpInfo.last.attributes).to include(expected)
      end
    end

    context 'with invalid ip' do
      it 'raises GeolocationResponseError error', :vcr do
        expect { service.call(ip: '1aasd3.3sd2.1d51.115') }.to(
          raise_error(IpGeolocationResponseHandler::GeolocationResponseError, 'The IP Address supplied is invalid.')
        )
      end
    end

    context 'with no params' do
      it 'raises ArgumentError error', :vcr do
        expect { service.call }.to(
          raise_error(ArgumentError, 'Requires a single IP as first parameter')
        )
      end
    end
  end
end
