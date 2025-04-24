require 'rails_helper'

RSpec.feature 'location forecast' do
  scenario 'a user requests for Indianapolis' do
    stub_request(:any, %r{http://remote_weather}).to_rack(Mocks::RemoteWeather)

    get '/v1/forecasts', params: {
      address1: '1234 Street Av',
      city: 'Indianapolis',
      state: 'IN',
      zip: '46255',
    }

    aggregate_failures do
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to contain_exactly(
        { "date" => Date.today.iso8601, "high" => 70, "low" => 50 }
      )
    end
  end

  scenario 'a user requests for Sacramento' do
    stub_request(:any, %r{http://remote_weather}).to_rack(Mocks::RemoteWeather)

    get '/v1/forecasts', params: {
      address1: '1234 Street Av',
      city: 'Sacramento',
      state: 'CA',
      zip: '11111',
    }

    aggregate_failures do
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to contain_exactly(
        { "date" => Date.today.iso8601, "high" => 80, "low" => 60 }
      )
    end
  end

  scenario 'a user forgets the address' do
    get '/v1/forecasts'

    aggregate_failures do
      expect(response.status).to eq(400)
    end
  end

  scenario 'the remote weather service is down' do
    stub_request(:any, %r{http://remote_weather}).to_rack(Mocks::FailingService)
    stub_request(:any, %r{http://remote_monitoring}).to_rack(Mocks::MonitoringService)

    get '/v1/forecasts', params: {
      address1: '1234 Street Av',
      city: 'Sacramento',
      state: 'CA',
      zip: '11111',
    }

    aggregate_failures do
      expect(response.status).to eq(500)
      expect(response.body).to eq('"Pardon the interruption"')
      expect(Mocks::MonitoringService.reports).to contain_exactly(
        {'msg' => 'remote_weather/forecasts failed with a 500 response.', 'cause' => 'my failure' }
      )
    end
  end
end
