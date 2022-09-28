class RoadtripFacade
  def self.create_roadtrip(origin, destination)
    coordinate_data = coordinates(destination)
    weather_data = WeatherService.location_weather(coordinate_data.lat, coordinate_data.long)
    location_data = MapService.trip_details(origin, destination)
    Roadtrip.new(location_data, weather_data)
  end

  def self.coordinates(location)
    Location.new(MapService.find_location(location))
  end
end