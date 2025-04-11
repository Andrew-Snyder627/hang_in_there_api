class Api::V1::PostersController < ApplicationController
  def index
    posters = Poster.sorted_by(params[:sort])
                    .filter_by(params[:name]).sorted_by(params[:sort])
                    .filter_by_price(min:params[:min_price], max: params[:max_price])
    render json: PosterSerializer.new(posters, meta: { count: posters.count }).serializable_hash
  end

  def show
    poster = Poster.find_by(id: params[:id])

    if poster
      render json: PosterSerializer.new(poster).serializable_hash
    else
      render json: { error: "Poster not found" }, status: :not_found
    end
  end

  def destroy
    poster = Poster.find_by(id: params[:id])

    if poster
      poster.destroy
      head :no_content #returns 204 exactly with no body
    else
      render json: { error: "Poster not found" }, status: :not_found
    end
  end
  
  def create
    poster = Poster.create(poster_params)
    render json: PosterSerializer.new(poster).serializable_hash
  end

  def update
    poster = Poster.find_by(id: params[:id])
    poster.update(poster_params)
    render json: PosterSerializer.new(poster).serializable_hash
  end

  private
    def poster_params
      params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url )
    end
end