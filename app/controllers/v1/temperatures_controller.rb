module V1
  class TemperaturesController < ApplicationController
    def current
      render json: WeatherService.get(address)
    end

    private
      def address
        Address.new(**params.permit(Address.members))
      end

      Address = Struct.new(:address1, :city, :state, :zip) do
        include ActiveModel::Validations
        validates *members, presence: true

        def initialize(*a, **b)
          super
          validate!
        end
      end
  end
end
