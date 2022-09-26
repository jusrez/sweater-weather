class Api::V1::BooksController < ApplicationController
  def index
    render json: BooksSerializer.new(BookFacade.book_destination_info(params[:location], params[:quantity]))
  end
end