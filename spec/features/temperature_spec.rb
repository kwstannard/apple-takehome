<<Reqs
Requirements:
    • Must be done in Ruby on Rails
    • Accept an address as input
    • Retrieve forecast data for the given address. This should include, at minimum, the current temperature (Bonus points - Retrieve high/low and/or extended forecast)
    • Display the requested forecast details to the user
    • Cache the forecast details for 30 minutes for all subsequent requests by zip codes. Display indicator if result is pulled from cache.
Reqs

require 'rails_helper'

RSpec.feature 'current temperature', type: :request do
  scenario 'a user requests for Indianapolis' do
    get '/v1/current_temperature', params: {
      address1: '1234 Street Av',
      city: 'Indianapolis',
      state: 'IN',
      zip: '46255',
    }

    stub_request("remote_weather").to(Mocks::RemoteWeather)

    aggregate_failures do
      expect(response.status).to eq(200)
      expect(response.body).to eq('{"current_temperature":70}')
    end
  end

  scenario 'a user requests for Sacramento' do
    get '/v1/current_temperature', params: {
      address1: '1234 Street Av',
      city: 'Sacramento',
      state: 'CA',
      zip: '11111',
    }

    stub_request("remote_weather").to(Mocks::RemoteWeather)

    aggregate_failures do
      expect(response.status).to eq(200)
      expect(response.body).to eq('{"current_temperature":50}')
    end
  end

  scenario 'a user forgets the address' do
    get '/v1/current_temperature'

    aggregate_failures do
      expect(response.status).to eq(400)
    end
  end

  scenario 'the remote weather service is down' do
    stub_request("remote_weather").to(Mocks::FailingService)

    get '/v1/current_temperature', params: {
      address1: '1234 Street Av',
      city: 'Sacramento',
      state: 'CA',
      zip: '11111',
    }

    aggregate_failures do
      expect(response.status).to eq(500)
      expect(response.body).to eq('"Pardon the interruption"')
      expect(Mocks::MonitorService.reports).to contain_exactly(
        [{error: '"http://remote_weather/get" failed with a 500' }]
      )
    end
  end
end
