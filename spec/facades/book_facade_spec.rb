require 'rails_helper'

RSpec.describe 'Book Facade' do
  it 'returns a Book Search object', :vcr do
    book_search = BookFacade.book_destination_info('denver,co', 3)

    expect(book_search).to be_a Book
    expect(book_search.destination).to eq('denver,co')
    expect(book_search.books.count).to eq(3)
  end
end