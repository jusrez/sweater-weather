require 'rails_helper'

RSpec.describe 'Weather Service' do
  it 'returns weather data for a specified location', :vcr do
    coordinates = [39.738453, -104.984853]
    weather = WeatherService.location_weather(coordinates[0], coordinates[1])

    expect(weather).to be_a(Hash)
    expect(weather).to have_key(:current)
    expect(weather).to have_key(:daily)
    expect(weather).to have_key(:hourly)
  end
end