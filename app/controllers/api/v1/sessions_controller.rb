class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: session_params[:email]) if session_params
    if user&.authenticate(session_params[:password])
      render json: UsersSerializer.new(user), status: 200
    elsif request.raw_post.empty?
      render json: { error: 'Missing JSON payload in request body'}, status: 400
    else
      render json: { error: 'Invalid credentials' }, status: 401
    end
  end

  private
  def session_params
    JSON.parse(request.raw_post, symbolize_names: true) unless request.raw_post.empty?
  end
end