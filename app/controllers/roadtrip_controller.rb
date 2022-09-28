class Api::V1::RoadtripController < ApplicationController
  def create
    user = User.find_by(api_key: roadtrip_params[:api_key]) if roadtrip_params
    roadtrip = RoadtripFacade.create_roadtrip(roadtrip_params[:origin], roadtrip_params[:destination]) if roadtrip_params
    if roadtrip      
      render json: RoadtripSerializer.new(roadtrip), status: 200
    elsif user == nil
      render json: { error: 'Invalid credentials' }, status: 401
    elsif request.raw_post.empty?
       render json: { error: 'Missing JSON payload in request body'}, stauts: 400
    else
      render json: { error: 'Both origin and destination must be included'}, stauts: 400
    end
  end

  private
  def roadtrip_params
    JSON.parse(request.raw_post, symbolize_names: true) unless request.raw_post.empty?
  end
end