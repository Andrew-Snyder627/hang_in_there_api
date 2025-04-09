require 'rails_helper'

describe "Posters API", type: :request do
  it "sends a list of posters" do
    Poster.create(name: "REGRET",
               description: "Hard work rarely pays off.",
               price: 89.00,
               year: 2018,
               vintage: true,
               img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")

    Poster.create(name: "FAILURE",
              description: "Why bother trying? It's probably not worth it.",
              price: 68.00,
              year: 2019,
              vintage: true,
              img_url: "https://img.industryweek.com/files/base/ebm/industryweek/image/2023/04/failure.6441a1c52787e.png?auto=format,compress&fit=crop&q=45&h=356&height=356&w=640&width=640")
               
    Poster.create(name: "MEDIOCRITY",
              description: "Dreams are just that—dreams.",
              price: 127.00,
              year: 2021,
              vintage: false,
              img_url: "https://miro.medium.com/v2/resize:fit:1400/1*xNps4qRlyJBVGnfJm3KvUw.jpeg")

    get '/api/v1/posters'

    expect(response).to be_successful

    json  = JSON.parse(response.body, symbolize_names: true)
    posters = json[:data]

    expect(posters.count).to eq(3)

  #   posters.each do |poster|
  #     expect(poster).to have_key(:id)
  #     expect(poster[:id].to_i).to be_an(Integer)

  #     expect(poster).to have_key(:name)
  #     expect(poster[:name]).to be_a(String)

  #     expect(poster).to have_key(:description)
  #     expect(poster[:description]).to be_a(String)

  #     expect(poster).to have_key(:price)
  #     expect(poster[:price]).to be_a(Float)

  #     expect(poster).to have_key(:year)
  #     expect(poster[:year]).to be_a(Integer)

  #     expect(poster).to have_key(:vintage)
  #     expect(poster[:vintage]).to be_a(Boolean)

  #     expect(poster).to have_key(:img_url)
  #     expect(poster[:img_url]).to be_a(String)
  #   end
  # end

  posters.each do |poster|
    expect(poster).to have_key(:id)
    expect(poster[:id].to_i).to be_an(Integer) # string in the serializer

    expect(poster).to have_key(:type)
    expect(poster[:type]).to eq("poster")

    expect(poster).to have_key(:attributes)

    attrs = poster[:attributes]

    expect(attrs[:name]).to be_a(String)
    expect(attrs[:description]).to be_a(String)
    expect(attrs[:price]).to be_a(Float)
    expect(attrs[:year]).to be_a(Integer)
    expect(attrs[:vintage]).to be_in([true, false])
    expect(attrs[:img_url]).to be_a(String)
  end
end

  it "can create a new poster" do
    poster_params = {
      "name": "DEFEAT",
      "description": "It's too late to start now.",
      "price": 35.00,
      "year": 2023,
      "vintage": false,
      "img_url":  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
    }
    headers = { "CONTENT_TYPE" => "application/json" }

    post "/api/v1/posters", headers: headers, params: JSON.generate(poster: poster_params)
    created_poster = Poster.last

    expect(response).to be_successful
    expect(created_poster.name).to eq(poster_params[:name])
    expect(created_poster.description).to eq(poster_params[:description])
    expect(created_poster.price).to eq(poster_params[:price])
    expect(created_poster.year).to eq(poster_params[:year])
    expect(created_poster.vintage).to eq(poster_params[:vintage])
    expect(created_poster.img_url).to eq(poster_params[:img_url])
  end
  it "can update an existing poster" do
    id = Poster.create("name": "DEFEAT",
      "description": "It's too late to start now.",
      "price": 35.00,
      "year": 2023,
      "vintage": false,
      "img_url":  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk").id
      previous_name = Poster.last.name
      poster_params = {name: "VANQUISH"}
      headers = { "CONTENT_TYPE" => "application/json" }

      patch "/api/v1/posters/#{id}", headers: headers, params: JSON.generate(poster: poster_params)
      poster = Poster.find_by(id: id)

      expect(response).to be_successful
      expect(poster.name).to_not eq(previous_name)
      expect(poster.name).to eq("VANQUISH")
  end
end