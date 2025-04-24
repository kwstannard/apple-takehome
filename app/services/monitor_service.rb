module MonitorService
  extend self

  def report(**opts)
    uri = URI.parse('http://remote_monitoring/reports')
    Net::HTTP.post(uri, opts.to_json, { 'Content-Type': 'application/json' })
  end
end
