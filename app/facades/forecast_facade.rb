class ForecastFacade
  def self.weather_by_location(location)
     coordinate_data = Location.new(MapService.find_location(location))
     Forecast.new(WeatherService.location_weather(coordinate_data.latitude, coordinate_data.longitude))
  end
end