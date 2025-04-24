module WeatherService
  extend self
  class Error < RuntimeError; end

  def forecasts(address)
    host = 'remote_weather'
    path = '/forecasts'
    r = Net::HTTP.get_response(host, "#{path}?#{URI.encode_www_form(address)}")

    case r.code
    when "200".."299"
      JSON.parse(r.body)
    else
      MonitorService.report(
        msg: "#{host}#{path} failed with a #{r.code} response.",
        cause: r.body,
      )
      raise Error, r.body
    end
  end

  def get(address)
    host = 'remote_weather'
    path = '/get'
    r = Net::HTTP.get_response(host, "#{path}?#{URI.encode_www_form(address)}")

    case r.code
    when "200".."299"
      JSON.parse(r.body)
    else
      MonitorService.report(
        msg: "#{host}#{path} failed with a #{r.code} response.",
        cause: r.body,
      )
      raise Error, r.body
    end
  end
end
