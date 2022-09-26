require 'rails_helper'

RSpec.describe 'Forecast API' do
  it 'gets the current weather, daily weather, and local weather for a specified location', :vcr do
    get '/api/v1/forecast?location=denver,co'

    expect(response).to be_successful

    forecast = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(forecast[:attributes].keys.count).to eq(3)
    expect(forecast[:attributes].keys.include?(:current_weather)).to eq(true)
    expect(forecast[:attributes].keys.include?(:daily_weather)).to eq(true)
    expect(forecast[:attributes].keys.include?(:hourly_weather)).to eq(true)    
  end

  it 'returns the datetime, sunrise, sunset, temperature, feels_like, humidity, uvi, visibility, conditions, and icon of the current weather', :vcr do
    get '/api/v1/forecast?location=denver,co'

    expect(response).to be_successful

    current_weather = JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:current_weather]
    
    expect(current_weather[:datetime]).to be_a String
    expect(current_weather[:sunrise]).to be_a String
    expect(current_weather[:sunset]).to be_a String
    expect(current_weather[:temperature]).to be_a Float
    expect(current_weather[:feels_like]).to be_a Float
    expect(current_weather[:humidity]).to be_a Integer or Float
    expect(current_weather[:uvi]).to be_a Integer or Float
    expect(current_weather[:visibility]).to be_a Integer or Float
    expect(current_weather[:conditions]).to be_a String
    expect(current_weather[:icon]).to be_a String

    expect(current_weather.keys.include?(:dew_point)).to eq(false)
    expect(current_weather.keys.include?(:pressure)).to eq(false)
    expect(current_weather.keys.include?(:clouds)).to eq(false)
    expect(current_weather.keys.include?(:wind_speed)).to eq(false)
    expect(current_weather.keys.include?(:wind_deg)).to eq(false)
    expect(current_weather.keys.include?(:wind_gust)).to eq(false)
  end

  it 'returns the date, sunrise, sunset, max temp, min temp, conditions, and icon of the next 5 days of daily weather', :vcr do
    get '/api/v1/forecast?location=denver,co'

    expect(response).to be_successful

    daily_weather = JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:daily_weather]
    
    expect(daily_weather.count).to eq(5)

    daily_weather.each do |day|
      expect(day[:date]).to be_a String
      expect(day[:sunrise]).to be_a String
      expect(day[:sunset]).to be_a String
      expect(day[:max_temp]).to be_a Float
      expect(day[:min_temp]).to be_a Float
      expect(day[:conditions]).to be_a String
      expect(day[:icon]).to be_a String

      expect(day.keys.include?(:moonrise)).to eq(false)
      expect(day.keys.include?(:moonset)).to eq(false)
      expect(day.keys.include?(:moon_phase)).to eq(false)
      expect(day.keys.include?(:wind_speed)).to eq(false)
      expect(day.keys.include?(:wind_deg)).to eq(false)
      expect(day.keys.include?(:wind_gust)).to eq(false)
    end  
  end

  it 'returns the time, temperature, conditions, and icon of the next 8 hours of hourly weather', :vcr do
    get '/api/v1/forecast?location=denver,co'

    expect(response).to be_successful

    hourly_weather = JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:hourly_weather]
    
    expect(hourly_weather.count).to eq(8)

    hourly_weather.each do |hour|
      expect(hour[:time]).to be_a String
      expect(hour[:temperature]).to be_a Float
      expect(hour[:conditions]).to be_a String
      expect(hour[:icon]).to be_a String

      expect(hour.keys.include?(:feels_like)).to eq(false)
      expect(hour.keys.include?(:pressure)).to eq(false)
      expect(hour.keys.include?(:humidity)).to eq(false)
      expect(hour.keys.include?(:dew_point)).to eq(false)
      expect(hour.keys.include?(:uvi)).to eq(false)
      expect(hour.keys.include?(:visibility)).to eq(false)
    end  
  end
end