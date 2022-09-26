require 'rails_helper'

RSpec.describe 'Book Requests' do
  it 'gets the search results by location and returns the quantity of books specified', :vcr do
    get '/api/v1/book-search?location=denver,co&quantity=5'

    expect(response).to be_successful

    book_results = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(book_results[:type]).to eq('books')
    expect(book_results[:attributes].keys.include?(:destination)).to eq(true)
    expect(book_results[:attributes].keys.include?(:forecast)).to eq(true)
    expect(book_results[:attributes].keys.include?(:total_books_found)).to eq(true)
    expect(book_results[:attributes].keys.include?(:books)).to eq(true)
    
    expect(book_results[:attributes][:books].count).to eq(5)
    expect(book_results[:attributes][:books][0].include?(:title)).to eq(true)
    expect(book_results[:attributes][:books][0].include?(:isbn)).to eq(true)
    expect(book_results[:attributes][:books][0].include?(:publisher)).to eq(true)
  end

end