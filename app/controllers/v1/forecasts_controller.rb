module V1
  class ForecastsController < ApplicationController
    def index
      render json: WeatherService.forecasts(address, dates)
    rescue WeatherService::Error
      render json: '"Pardon the interruption"', status: 500
    end

    private
      def address
        Address.new(**params.permit(Address.members))
      end

      def dates
        if params[:start_date] && params[:end_date]
          (params[:start_date].to_date..params[:end_date].to_date).map(&:iso8601)
        else
          [Date.today.iso8601]
        end
      end
  end
end
