class Api::V1::PostersController < ApplicationController
  def index
    posters = Poster.all
    render json: {
      data: PosterSerializer.format_posters(posters)[:data],
      meta: {
        count: posters.count
      }
    }
  end

  def show
    poster = Poster.find_by(id: params[:id])

    if poster
      render json: PosterSerializer.format_poster(poster)
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
    render json: Poster.create(poster_params)
  end

  def update
    render json: Poster.update(params[:id], poster_params)
  end

  private
    def poster_params
      params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url )
    end
end