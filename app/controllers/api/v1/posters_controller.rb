class Api::V1::PostersController < ApplicationController
  def index
    posters = Poster.all
    render json: PosterSerializer.format_posters(posters)
  end

  def show
    poster = Poster.find_by(id: params[:id])

    if poster
      render json: PosterSerializer.format_poster(poster)
    else
      render json: { error: "Poster not found" }, status: :not_found
    end
  end
end