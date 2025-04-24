require 'webmock_patch'

module Mocks
  class RemoteWeather < Rails::Engine
    isolate_namespace self
    config.api_only = true

    routes.draw do
      get :get, to: 'weather#get'
    end

    class WeatherController < ActionController::API
      def get
        render json: if params[:state] == 'CA'
          { current_temperature: 50 }
        else
          { current_temperature: 70 }
        end
      end
    end
  end
end
