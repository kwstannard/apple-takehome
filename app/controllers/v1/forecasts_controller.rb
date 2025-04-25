module V1
  class ForecastsController < ApplicationController
    def index
      wf, cache_info = WeatherService.forecasts(address, dates)
      propogate_cache_info_to_headers(cache_info)
      render json: wf
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

      def propogate_cache_info_to_headers(cache_info)
        return unless cache_info

        response.headers['x-server-cache-info'] = {
          'obtained-at' => Time.at(cache_info.expires_at - 30.minutes).utc.iso8601,
          'expires-at' => Time.at(cache_info.expires_at).utc.iso8601,
        }
      end
  end
end
