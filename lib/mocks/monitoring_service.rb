require 'webmock_patch'

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
