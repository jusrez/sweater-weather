class ForecastFacade
  def self.weather_by_location(location)
     coordinate_data = coordinates(location)
     weather(coordinate_data)
  end

  def self.coordinates(location)
    Location.new(MapService.find_location(location))
  end

  def self.weather(coordinates)
    Forecast.new(WeatherService.location_weather(coordinates.lat, coordinates.long))
  end
end