class PosterSerializer
  def self.format_posters(posters) # Collection of poster
    {
      data: posters.map do |poster|
        format_poster_data(poster)
      end
    }
  end

  def self.format_poster(poster) # Single poster
    {
      data: format_poster_data(poster)
    }
  end

  def self.format_poster_data(poster) # Shared format
    {
      id: poster.id.to_s,
      type: "poster",
      attributes: {
        name: poster.name,
        description: poster.description,
        price: poster.price,
        year: poster.year,
        vintage: poster.vintage,
        img_url: poster.img_url
      }
    }
  end
end