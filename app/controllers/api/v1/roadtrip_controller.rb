class Api::V1::RoadtripController < ApplicationController
  def create
    user = User.find_by(api_key: roadtrip_params[:api_key]) if roadtrip_params
    if user && roadtrip_params.include?(:origin) && roadtrip_params.include?(:destination)
      roadtrip = RoadtripFacade.create_roadtrip(roadtrip_params[:origin], roadtrip_params[:destination])   
      render json: RoadtripSerializer.new(roadtrip), status: 200
    elsif request.raw_post.empty?
      render json: { error: 'Missing JSON payload in request body'}, status: 400
    elsif user == nil && roadtrip_params.include?(:origin) && roadtrip_params.include?(:destination)
      render json: { error: 'Invalid credentials' }, status: 401
    else
      render json: { error: 'Both origin and destination must be included'}, status: 400
    end
  end

  private
  def roadtrip_params
    JSON.parse(request.raw_post, symbolize_names: true) unless request.raw_post.empty?
  end
end