class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render json: UsersSerializer.new(user), status: 201
    else
      render json: { error: user.errors.full_messages * ', ' }, status: 400
    end
  end

  private
  def user_params
    JSON.parse(request.raw_post, symbolize_names: true)
  end
end