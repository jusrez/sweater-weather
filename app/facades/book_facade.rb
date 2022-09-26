class BookFacade
  def self.book_destination_info(destination, quantity = 1)
    coordinate_data = Location.new(MapService.find_location(destination))
    weather_data = WeatherService.location_weather(coordinate_data.latitude, coordinate_data.longitude)
    book_data = BookService.search_by_location(destination)
    Book.new(destination, weather_data, book_data, quantity)
  end
end