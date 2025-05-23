require 'rails_helper'

RSpec.feature 'location forecast' do
  scenario 'a user requests for Indianapolis for 3-8 days from now' do
    # Arrange
    stub_request(:any, %r{http://remote_weather}).to_rack(Mocks::RemoteWeather)

    # Act
    get '/v1/forecasts', params: {
      address1: '1234 Street Av',
      city: 'Indianapolis',
      state: 'IN',
      zip: '46255',
      start_date: 3.days.from_now.to_date.iso8601,
      end_date: 8.days.from_now.to_date.iso8601,
    }

    # Assert
    aggregate_failures do
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to contain_exactly(
        { "date" => 3.days.from_now.to_date.iso8601, "high" => 70, "low" => 50 },
        { "date" => 4.days.from_now.to_date.iso8601, "high" => 70, "low" => 50 },
        { "date" => 5.days.from_now.to_date.iso8601, "high" => 70, "low" => 50 },
        { "date" => 6.days.from_now.to_date.iso8601, "high" => 70, "low" => 50 },
        { "date" => 7.days.from_now.to_date.iso8601, "high" => 70, "low" => 50 },
        { "date" => 8.days.from_now.to_date.iso8601, "high" => 70, "low" => 50 },
      )
    end
  end

  scenario 'a user requests a forecast every 20 minutes and hits the cache' do
    stub_request(:any, %r{http://remote_weather}).to_rack(Mocks::RemoteWeather)

    # This will not be cached
    get '/v1/forecasts', params: {
      address1: '1234 Street Av',
      city: 'Indianapolis',
      state: 'IN',
      zip: '46255',
    }


    # This will be cached
    freeze_time(20.minutes.from_now) do
      get '/v1/forecasts', params: {
        address1: '1234 Street Av',
        city: 'Indianapolis',
        state: 'IN',
        zip: '46255',
      }
    end

    # This will not be cached
    freeze_time(40.minutes.from_now) do
      get '/v1/forecasts', params: {
        address1: '1234 Street Av',
        city: 'Indianapolis',
        state: 'IN',
        zip: '46255',
      }
    end

    # This will be from cache
    freeze_time(60.minutes.from_now) do
      get '/v1/forecasts', params: {
        address1: '1234 Street Av',
        city: 'Indianapolis',
        state: 'IN',
        zip: '46255',
      }

      aggregate_failures do
        expect(response.status).to eq(200)
        expect(response.headers["x-server-cache-info"]).to eq(
          { 'obtained-at' => 20.minutes.ago.iso8601, 'expires-at' => 10.minutes.from_now.iso8601 }
        )
        expect(JSON.parse(response.body)).to contain_exactly(
          { "date" => Date.today.iso8601, "high" => 70, "low" => 50 }
        )
      end
    end

    expect(a_request(:get, %r{http://remote_weather/forecast})).to have_been_made.times(2)
  end

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
