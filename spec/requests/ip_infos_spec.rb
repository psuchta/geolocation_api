require 'rails_helper'

RSpec.describe 'IpInfos', type: :request do
  describe 'GET /index' do
    let!(:ip_info) { FactoryBot.create(:ip_info, ip: '8.8.8.8') }
    let!(:ip_info_url) { FactoryBot.create(:ip_info, ip: '8.8.8.2', url: 'funpart.pl') }

    it 'returns status code 200' do
      get '/api/v1/ip_infos', params: { ip: '8.8.8.8' }

      expect(response).to have_http_status(200)
    end

    context 'based on Ip param' do
      context 'when ip is in the database' do
        it 'returns requested IP' do
          expected = {
            'city' => 'Ostrów Mazowiecka',
            'continent_name' => 'Europe',
            'country_name' => 'Poland',
            'ip' => '8.8.8.8',
            'ip_type' => 'ipv4',
            'latitude' => '52.80529022216797',
            'longitude' => '21.8941707611084',
            'region_name' => 'Mazovia',
            'url' => 'www.google.pl',
            'zip' => '07-300'
          }
          get '/api/v1/ip_infos', params: { ip: '8.8.8.8' }

          expect(json['data']).to include(expected)
        end
      end

      context 'when ip is not in the database' do
        it 'returns 404 code with message' do
          get '/api/v1/ip_infos', params: { ip: '7.7.7.7' }

          expect(response).to have_http_status(404)
          expect(json['message']).to eq('Requested resource cannot be found in the database')
        end
      end
    end

    context 'based on Url param' do
      context 'when url is in the database' do
        it 'returns requested IP/Url' do
          expected = {
            'city' => 'Ostrów Mazowiecka',
            'continent_name' => 'Europe',
            'country_name' => 'Poland',
            'ip' => '8.8.8.2',
            'ip_type' => 'ipv4',
            'latitude' => '52.80529022216797',
            'longitude' => '21.8941707611084',
            'region_name' => 'Mazovia',
            'url' => 'funpart.pl',
            'zip' => '07-300'
          }
          get '/api/v1/ip_infos', params: { url: 'www.funpart.pl' }

          expect(json['data']).to include(expected)
        end
      end

      context 'when Url is not in the database' do
        it 'returns 404 code with message' do
          get '/api/v1/ip_infos', params: { url: '404.pl' }

          expect(response).to have_http_status(404)
          expect(json['message']).to eq('Requested resource cannot be found in the database')
        end
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:ip_info) { FactoryBot.create(:ip_info, ip: '8.8.8.8') }
    let!(:ip_info2) { FactoryBot.create(:ip_info, ip: '7.7.7.7') }
    let!(:ip_info_url) { FactoryBot.create(:ip_info, ip: '8.8.8.2', url: 'funpart.pl') }

    context 'based on IP param' do
      it 'returns status code 200' do
        delete '/api/v1/ip_infos', params: { ip: '8.8.8.8' }

        expect(response).to have_http_status(200)
      end

      context 'when ip is in the database' do
        it 'deletes requested IP' do
          expect { delete '/api/v1/ip_infos', params: { ip: '8.8.8.8' } }
            .to change { IpInfo.count }.by(-1)

          expect(json['message']).to eq('Destroyed successfully')
        end
      end

      context 'when ip is not in the database' do
        it 'returns 404 code with message' do
          delete '/api/v1/ip_infos', params: { ip: '0.6.8.8' }

          expect(response).to have_http_status(404)
          expect(json['message']).to eq('Requested resource cannot be found in the database')
        end
      end
    end

    context 'based on Url param' do
      it 'returns status code 200' do
        delete '/api/v1/ip_infos', params: { url: 'www.funpart.pl' }

        expect(response).to have_http_status(200)
      end

      context 'when ip is in the database' do
        it 'deletes requested IP' do
          expect { delete '/api/v1/ip_infos', params: { url: 'www.funpart.pl' } }
            .to change { IpInfo.count }.by(-1)

          expect(json['message']).to eq('Destroyed successfully')
        end
      end

      context 'when ip is not in the database' do
        it 'returns 404 code with message' do
          delete '/api/v1/ip_infos', params: { url: 'www.fasdfasfasfunpart.pl' }

          expect(response).to have_http_status(404)
          expect(json['message']).to eq('Requested resource cannot be found in the database')
        end
      end
    end
  end

  describe 'POST /create' do
    let!(:ip_info) { FactoryBot.create(:ip_info, ip: '8.8.8.8', latitude: 12.12) }

    context 'based on Ip param' do
      it 'returns status code 200', :vcr do
        post '/api/v1/ip_infos', params: { ip: '7.7.7.7' }

        expect(response).to have_http_status(200)
      end

      context 'when ip is in the database' do
        it 'updates IP with new geodata', :vcr do
          expect { post '/api/v1/ip_infos', params: { ip: '8.8.8.8' } }
            .to change { IpInfo.count }.by(0)

          expect(json['data']['latitude']).to eq('40.5369987487793')
          expect(ip_info.reload.latitude).to eq(0.405369987487793e2)
        end
      end

      context 'when ip is not in the database' do
        it 'creates new ip in the database', :vcr do
          expected = {
            'city' => 'Ashburn',
            'continent_name' => 'North America',
            'country_name' => 'United States',
            'ip' => '7.7.7.7',
            'ip_type' => 'ipv4',
            'latitude' => '39.043701171875',
            'longitude' => '-77.47419738769531',
            'region_name' => 'Virginia',
            'url' => nil,
            'zip' => '20147'
          }

          expect { post '/api/v1/ip_infos', params: { ip: '7.7.7.7' } }
            .to change { IpInfo.count }.by(1)

          expect(json['data']).to include(expected)
        end
      end
    end
  end
end
