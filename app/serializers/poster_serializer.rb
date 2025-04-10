class PosterSerializer
  include JSONAPI::Serializer

  set_type :poster
  attributes :name, :description, :price, :year, :vintage, :img_url
end
