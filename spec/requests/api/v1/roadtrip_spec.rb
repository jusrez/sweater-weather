require 'rails_helper'

RSpec.describe 'Road Trip' do
  before :each do
    @user = User.create!(email: 'tester@testing.com', password: 'thepassword', password_confirmation: 'thepassword')
  end

  it 'returns the start_city, end_city, travel_time, and weather_at_eta when an origin, destination, and valid_api_key are provided in a post request', :vcr do
    params = {
      origin: 'Denver,CO',
      destination: 'Pueblo,CO',
      api_key: @user.api_key
    }

    post '/api/v1/road_trip', params: params.to_json

    expect(response).to be_successful
    
    roadtrip = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(roadtrip).to be_a(Hash)
    expect(roadtrip[:id]).to be_nil
    expect(roadtrip[:type]).to eq('roadtrip')
    expect(roadtrip[:attributes]).to have_key(:start_city)
    expect(roadtrip[:attributes][:start_city]).to eq('Denver, CO')

    expect(roadtrip[:attributes]).to have_key(:end_city)
    expect(roadtrip[:attributes][:end_city]).to eq('Pueblo, CO')

    expect(roadtrip[:attributes][:travel_time]).to be_a(String)

    expect(roadtrip[:attributes][:weather_at_eta]).to have_key(:temperature)
    expect(roadtrip[:attributes][:weather_at_eta]).to have_key(:conditions)
    expect(roadtrip[:attributes][:weather_at_eta][:conditions]).to be_a(String)
  end

  it 'returns a travel time of impossible if the destination cannot be reached by driving', :vcr do
    params = {
      origin: 'New York,NY',
      destination: 'London,UK',
      api_key: @user.api_key
    }

    post '/api/v1/road_trip', params: params.to_json

    expect(response).to be_successful
    roadtrip = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(roadtrip).to have_key(:attributes)
    expect(roadtrip[:attributes]).to be_a(Hash)

    expect(roadtrip[:attributes]).to have_key(:start_city)
    expect(roadtrip[:attributes][:start_city]).to be_nil

    expect(roadtrip[:attributes]).to have_key(:end_city)
    expect(roadtrip[:attributes][:end_city]).to be_nil

    expect(roadtrip[:attributes]).to have_key(:travel_time)
    expect(roadtrip[:attributes][:travel_time]).to eq('impossible route')

    expect(roadtrip[:attributes][:weather_at_eta]).to be_nil
  end

  it 'returns an error when an unassigned api key is provided' do
    params = {
      origin: 'Denver,CO',
      destination: 'Pueblo,CO',
      api_key: '123'
    }

    post '/api/v1/road_trip', params: params.to_json

    expect(response.status).to eq(401)
    
    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(error_response).to be_a(Hash)
    expect(error_response).to have_key(:error)
    expect(error_response[:error]).to eq('Invalid credentials')
  end

  it 'returns an error when no api key is given' do
    params = {
      origin: 'Denver,CO',
      destination: 'Pueblo,CO'
    }

    post '/api/v1/road_trip', params: params.to_json

    expect(response.status).to eq(401)
    
    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(error_response).to be_a(Hash)
    expect(error_response).to have_key(:error)
    expect(error_response[:error]).to eq('Invalid credentials')
  end

  it 'returns an error when no destination is given' do
    params = {
      origin: 'Denver,CO',
      api_key: User.last.api_key
    }

    post '/api/v1/road_trip', params: params.to_json

    expect(response.status).to eq(400)
    
    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(error_response).to be_a(Hash)
    expect(error_response).to have_key(:error)
    expect(error_response[:error]).to eq('Both origin and destination must be included')
  end

  it 'returns an error when no origin is given' do
    params = {
      destination: 'Pueblo,CO',
      api_key: User.last.api_key
    }

    post '/api/v1/road_trip', params: params.to_json

    expect(response.status).to eq(400)

    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(error_response).to be_a(Hash)
    expect(error_response).to have_key(:error)
    expect(error_response[:error]).to eq('Both origin and destination must be included')
  end

  it 'returns an error when no JSON payload is provided' do
   
    post "/api/v1/road_trip?origin=Denver,CO&destination=Pueblo,CO&api_key=#{@user.api_key}"
    
    expect(response.status).to eq(400)

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_response).to eq({ error: 'Missing JSON payload in request body' })
  end
end