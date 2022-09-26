class Api::V1::ForecastsController < ApplicationController
  def show
    render json: ForecastSerializer.new(ForecastFacade.weather_by_location(params[:location]))
  end
end
