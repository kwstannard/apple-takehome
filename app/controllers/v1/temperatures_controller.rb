module V1
  class TemperaturesController < ApplicationController
    def current
      address
      render json: { current_temperature: 50 }
    end

    private
      def address
        params.require(:address1)
        params.require(:city)
        params.require(:state)
        params.require(:zip)
      end
  end
end
