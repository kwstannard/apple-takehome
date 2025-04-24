require 'webmock_patch'

module Mocks
  class RemoteWeather < Rails::Engine
    isolate_namespace self
    config.api_only = true

    routes.draw do
      get :get, to: 'weather#get'
      get :forecasts, to: 'weather#forecasts'
    end

    class WeatherController < ActionController::API
      def get
        render json: if params[:state] == 'CA'
          { current_temperature: 50 }
        else
          { current_temperature: 70 }
        end
      end

      def forecasts
        render json: params.require(:dates).map { fake_forecast(_1) }
      end

      def fake_forecast(date)
        if params[:state] == 'CA'
          { date: date, high: 80, low: 60 }
        else
          { date: date, high: 70, low: 50 }
        end
      end
    end
  end
end
