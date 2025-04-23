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
  scenario 'a user requests for Sacremento' do
    get '/v1/current_temperature', params: {
      address1: '1234 Street Av',
      city: 'Sacremento',
      state: 'Ca',
      zip: '11111',
    }

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
end
