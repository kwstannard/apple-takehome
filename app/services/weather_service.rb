module WeatherService
  extend self
  class Error < RuntimeError; end

  attr_accessor :cache
  self.cache = ActiveSupport::Cache::FileStore.new(Tempfile.new('forecasts'))

  def forecasts(address, dates)
    all_forecasts(address).select {|f| dates.inspect.include?(f['date']) }
  end

  def all_forecasts(address)
    cache.fetch(address.zip, expires_in: 30.minutes, skip_nil: true) do
      host = 'remote_weather'
      path = '/forecasts'
      uri_addr = URI.encode_www_form(address)
      uri_dates = URI.encode_www_form({'dates[]' => (Date.today..30.days.from_now.to_date).to_a})
      r = Net::HTTP.get_response(host, "#{path}?#{uri_addr}&#{uri_dates}")

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
