require 'rails_helper'

RSpec.describe Book do
  it 'exists', :vcr do
    coordinate_data = Location.new(MapService.find_location('denver,co'))
    book_data = BookService.search_by_location('denver,co')
    weather_data = WeatherService.location_weather(coordinate_data.latitude, coordinate_data.longitude)
    book = Book.new('denver,co', weather_data, book_data, 4)

    expect(book).to be_an_instance_of Book
    expect(book.id).to eq(nil)
    expect(book.destination).to eq('denver,co')
    expect(book.forecast).to be_a Hash
    expect(book.forecast.include?(:summary)).to eq(true)
    expect(book.forecast.include?(:temperature)).to eq(true)
    expect(book.total_books_found).to be_a(Integer)
    expect(book.books.count).to eq(4)
    expect(book.books[0].keys.include?(:isbn)).to eq(true)
    expect(book.books[0].keys.include?(:title)).to eq(true)
    expect(book.books[0].keys.include?(:publisher)).to eq(true)
  end
end