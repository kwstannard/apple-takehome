module V1
  class TemperaturesController < ApplicationController
    def current
      render json: WeatherService.get(address)
    rescue WeatherService::Error
      render json: '"Pardon the interruption"', status: 500
      raise if ENV['DEBUG']
    end

    private
      def address
        Address.new(**params.permit(Address.members))
      end
  end
end
