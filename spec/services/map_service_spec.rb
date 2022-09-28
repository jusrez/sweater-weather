require 'rails_helper'

RSpec.describe 'Map Service' do
  it 'returns location data for a specified location', :vcr do
    location = MapService.find_location('denver,co')

    expect(location).to be_a(Hash)
    expect(location).to have_key(:results)
    expect(location[:results][0]).to have_key(:locations)
    expect(location[:results][0][:locations][0]).to have_key(:latLng)
    expect(location[:results][0][:locations][0][:latLng][:lat]).to be_a Float
    expect(location[:results][0][:locations][0][:latLng][:lng]).to be_a Float
  end
end