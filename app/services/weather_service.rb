module WeatherService
  extend self

  def get(address)
    if address.state == 'CA'
      { current_temperature: 50 }
    else
      { current_temperature: 70 }
    end
  end
end
