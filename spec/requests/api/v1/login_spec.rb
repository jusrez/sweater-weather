require 'rails_helper'

RSpec.describe 'Login Request' do
  before :each do
    User.create!(email: 'test@testing.com', password: 'thepassword', password_confirmation: 'thepassword')
  end

  it 'returns a users email and api key upon successful login' do 
    params = {
      email: 'test@testing.com',
      password: 'thepassword'
    }

    post '/api/v1/sessions', params: params.to_json

    expect(response).to be_successful
    expect(response.status).to eq(200)

    parsed_response = JSON.parse(response.body, symbolize_names: true)

    expect(parsed_response[:data][:type]).to eq('users')
    expect(parsed_response[:data][:id].to_i).to be_a(Integer)

    expect(parsed_response[:data][:attributes]).to have_key(:email)
    expect(parsed_response[:data][:attributes][:email]).to eq(User.last.email)

    expect(parsed_response[:data][:attributes]).to have_key(:api_key)
    expect(parsed_response[:data][:attributes][:api_key]).to be_a(String)

    expect(parsed_response[:data][:attributes]).to_not have_key(:password)
    expect(parsed_response[:data][:attributes]).to_not have_key(:password_confirmation)
    expect(parsed_response[:data][:attributes]).to_not have_key(:password_digest)
  end

  it 'returns an error when the incorrect password is given' do
    params = {
      email: 'test@testing.com',
      password: 'WRONGPASSWORD'
    }

    post '/api/v1/sessions', params: params.to_json

    expect(response.status).to eq(401)

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_response).to eq({ error: 'Invalid credentials' })
  end

  it 'returns an error when the email is not given' do
    params = {
      password: 'thepassword'
    }

    post '/api/v1/sessions', params: params.to_json

    expect(response.status).to eq(401)

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_response).to eq({ error: 'Invalid credentials' })
  end

  it 'returns an error when the password is not given' do
    params = {
      email: 'test@testing.com'
    }

    post '/api/v1/sessions', params: params.to_json

    expect(response.status).to eq(401)

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_response).to eq({ error: 'Invalid credentials' })
  end

  it 'returns an error when there isnt a JSON payload' do

    post '/api/v1/sessions?email=test@testing.com&password=thepassword'
    
    expect(response.status).to eq(400)
    
    parsed_response = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_response).to eq({ error: 'Missing JSON payload in request body' })
  end
end