module Mocks
  class MonitoringService < Rails::Engine
    isolate_namespace self
    config.api_only = true
    attr_accessor :reports

    instance.reports = []

    routes.draw do
      resource :reports, only: [ :create ]
    end

    class ReportsController < ActionController::Base
      def create
        MonitoringService.reports << params.permit(:msg, :cause).to_h
        render json: '"success"'
      end
    end
  end
end

# webmock patch. webmock sets rack.session to {}, which blows up rails as rails 
# needs a session object.
# https://github.com/bblimke/webmock/issues/985
WebMock::RackResponse.prepend(Module.new do
  def build_rack_env(*)
    super.tap {
      _1.delete('rack.session')
      _1.delete('rack.session.options')
    }
  end
end)
