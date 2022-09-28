require 'rails_helper'

RSpec.describe 'Register Request' do
  it 'will return a response with the email and api_key when a user is successfuly created after a post request' do
    params = {
      email: 'test@testing.com',
      password: 'password',
      password_confirmation: 'password'
    }

    post '/api/v1/users', params: params.to_json

    expect(response).to be_successful
    expect(response.status).to eq(201)

    parsed_response = JSON.parse(response.body, symbolize_names: true)

    expect(parsed_response).to have_key(:data)
    expect(parsed_response[:data]).to have_key(:type)
    expect(parsed_response[:data][:type]).to eq('users')
    expect(parsed_response[:data]).to have_key(:id)
    expect(parsed_response[:data][:id].to_i).to be_a(Integer)
    expect(parsed_response[:data]).to have_key(:attributes)
    expect(parsed_response[:data][:attributes].keys.length).to eq(2)
    expect(parsed_response[:data][:attributes]).to have_key(:email)
    expect(parsed_response[:data][:attributes][:email]).to eq(User.last.email)
    expect(parsed_response[:data][:attributes]).to have_key(:api_key)
    expect(parsed_response[:data][:attributes][:api_key]).to be_a(String)
    expect(parsed_response[:data][:attributes]).to_not have_key(:password)
    expect(parsed_response[:data][:attributes]).to_not have_key(:password_confirmation)
    expect(parsed_response[:data][:attributes]).to_not have_key(:password_digest)
  end

  it 'returns an error when the password and password confirmation do not match' do
    params = {
      'email': 'testing@testing.com',
      'password': 'thepassword',
      'password_confirmation': 'WRONGPASSWORD'
    }

    post '/api/v1/users', params: params.to_json

    expect(response.status).to eq(400)

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_response).to eq({ error: "Password confirmation doesn't match Password" })
  end

  it 'returns an error when password confirmation isnt provided' do
    params = {
      'email': 'test@testing.com',
      'password': 'thepassword'
    }

    post '/api/v1/users', params: params.to_json

    expect(response.status).to eq(400)

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_response).to eq({ error: "Password confirmation can't be blank" })
  end

  it 'returns an error when email isnt provided' do
    params = {
      'password': 'thepassword',
      'password_confirmation': 'thepassword'
    }

    post '/api/v1/users', params: params.to_json

    expect(response.status).to eq(400)

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_response).to eq({ error: "Email can't be blank" })
  end

  it 'returns an error when the email has already been used' do
    params = {
      'email': 'test@testing.com',
      'password': 'thepassword',
      'password_confirmation': 'thepassword'
    }

    post '/api/v1/users', params: params.to_json

    expect(response).to be_successful
    expect(response.status).to eq(201)

    post '/api/v1/users', params: params.to_json

    expect(response.status).to eq(400)

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_response).to eq({ error: 'Email has already been taken' })
  end

  it 'returns an error when params are not passed through JSON payload' do

    post '/api/v1/users?email=test@testing.com&password=thepassword&password_confirmation=thepassword'

    expect(response.status).to eq(400)

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_response).to eq({ error: 'Missing JSON payload in request body' })
  end
end