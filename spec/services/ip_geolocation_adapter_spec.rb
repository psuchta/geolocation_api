require 'rails_helper'

RSpec.describe IpGeolocationAdapter, type: :model do
  describe '#ip_geolocation' do
    let(:service) { IpGeolocationAdapter.new }

    it 'returns hash with geolocation data', :vcr do
      expected_hash = {
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

      result = service.ip_geolocation('8.8.8.8')
      expect(result).to eq(expected_hash)
    end

    context 'when ip address is valud url' do
      it 'returns hash with geolocation data', :vcr do
        expected_hash = {
          ip: '212.77.98.9',
          ip_type: 'ipv4',
          continent_name: 'Europe',
          country_name: 'Poland',
          region_name: 'Pomerania',
          city: 'Gdańsk',
          zip: '80-009',
          latitude: 54.31930923461914,
          longitude: 18.63736915588379
        }

        result = service.ip_geolocation('www.wp.pl')
        expect(result).to eq(expected_hash)
      end
    end

    context 'when special ip (private, localhost)' do
      it 'returns empty hash', :vcr do
        expected_hash = {
          ip: '127.0.0.1',
          ip_type: 'ipv4',
          continent_name: nil,
          country_name: nil,
          region_name: nil,
          city: nil,
          zip: nil,
          latitude: 0.0,
          longitude: 0.0
        }

        result = service.ip_geolocation('127.0.0.1')
        expect(result).to eq(expected_hash)
      end
    end

    context 'when ip is ipv6' do
      it 'returns correct response', :vcr do
        expected_hash = {
          ip: '2001:db8:3333:4444:CCCC:DDDD:EEEE:FFFF',
          ip_type: 'ipv6',
          continent_name: nil,
          country_name: nil,
          region_name: nil,
          city: nil,
          zip: nil,
          latitude: 0.0,
          longitude: 0.0
        }

        result = service.ip_geolocation('2001:db8:3333:4444:CCCC:DDDD:EEEE:FFFF')
        expect(result).to eq(expected_hash)
      end
    end

    context 'when ip address is invalid url' do
      it 'raises GeolocationResponseError with a message', :vcr do
        expect { service.ip_geolocation('www.fgjosldffgruchavlksmfvljssdfsd.pl') }.to(
          raise_error(IpGeolocationResponseHandler::GeolocationResponseError, 'The IP Address supplied is invalid.')
        )
      end
    end

    context 'when ip address is url with https' do
      it 'raises GeolocationResponseError with a message', :vcr do
        expect { service.ip_geolocation('https://www.wp.pl/') }.to(
          raise_error(IpGeolocationResponseHandler::GeolocationResponseError, 'Not Found')
        )
      end
    end

    context 'when ip address is invalid' do
      it 'raises GeolocationResponseError with a message', :vcr do
        expect { service.ip_geolocation('8.8') }.to(
          raise_error(IpGeolocationResponseHandler::GeolocationResponseError, 'The IP Address supplied is invalid.')
        )
      end
    end

    context 'when ip address is empty' do
      it 'raises ArgumentError with a message', :vcr do
        expect { service.ip_geolocation('') }.to(
          raise_error(ArgumentError, 'Requires a single IP as first parameter')
        )
      end
    end
  end
end
