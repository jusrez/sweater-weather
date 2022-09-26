class Book

  attr_reader :id, :destination, :forecast, :total_books_found, :books
  def initialize(destination, weather_data, book_data, quantity)
    @id = nil
    @destination = destination
    @forecast = forecast_details(weather_data)
    @total_books_found = book_data[:numFound]
    @books = book_details(book_data, quantity.to_i)
  end

  def book_details(book_data, quantity)
    book_data[:docs].first(quantity).map do |book|
    {
      isbn: book[:isbn],
      title: book[:title],
      publisher: book[:publisher]
    }
    end
  end

  def forecast_details(weather_data)
    {
      summary: weather_data[:current][:weather][0][:description],
      temperature: weather_data[:current][:temp]
    }
  end

end