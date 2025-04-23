module V1
  class TemperaturesController < ApplicationController
    def current
      render json: { current_temperature: 50 }
    end
  end
end
