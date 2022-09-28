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

  it 'returns trip data when a origin and destination are provided', :vcr do
    trip = MapService.trip_details('denver,co', 'pueblo,co')
    
    expect(trip).to be_a(Hash)
    expect(trip).to have_key(:route)
    expect(trip[:route][formattedTime]).to be_a String
    expect(trip[:route][:locations].first[:adminArea5]).to eq('Denver')
    expect(trip[:route][:locations].first[:adminArea3]).to eq('CO')
    expect(trip[:route][:locations].last[:adminArea5]).to eq('Pueblo')
    expect(trip[:route][:locations].last[:adminArea3]).to eq('CO')
  end
end