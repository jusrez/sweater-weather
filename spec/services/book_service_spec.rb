require 'rails_helper'

RSpec.describe 'Book Service' do
  it 'returns books that are relevant to a given location', :vcr do
    book_results = BookService.search_by_location('denver,co')
    
    expect(book_results).to be_a Hash 
    expect(book_results[:docs][1].include?(:isbn)).to eq(true)
    expect(book_results[:docs][1].include?(:title)).to eq(true)
    expect(book_results[:docs][1].include?(:publisher)).to eq(true)
  end
end