module V1
  class ForecastsController < ApplicationController
    def index
      render json: WeatherService.forecasts(address)
    rescue WeatherService::Error
      render json: '"Pardon the interruption"', status: 500
    end

    private
      def address
        Address.new(**params.permit(Address.members))
      end
  end
end
