require 'rails_helper'

RSpec.feature 'location forecast' do
  scenario 'a user requests for Indianapolis' do
  end

  scenario 'a user requests for Sacramento' do
  end

  scenario 'a user forgets the address' do
    get '/v1/forecasts'

    aggregate_failures do
      expect(response.status).to eq(400)
    end
  end

  scenario 'the remote weather service is down' do
  end
end
