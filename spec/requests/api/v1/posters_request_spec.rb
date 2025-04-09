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

    response_body = JSON.parse(response.body, symbolize_names: true)
    posters = response_body[:data]

    expect(posters).to be_an(Array)
    expect(posters.count).to eq(3)

    posters.each do |poster|
      expect(poster).to have_key(:id)
      expect(poster[:id]).to be_a(String)

      expect(poster).to have_key(:type)
      expect(poster[:type]).to eq("poster")
      
      expect(poster).to have_key(:attributes)

      attrs = poster[:attributes]

      expect(attrs).to have_key(:name)
      expect(attrs[:name]).to be_a(String)

      expect(attrs).to have_key(:description)
      expect(attrs[:description]).to be_a(String)

      expect(attrs).to have_key(:price)
      expect(attrs[:price]).to be_a(Float).or be_a(Integer)

      expect(attrs).to have_key(:year)
      expect(attrs[:year]).to be_a(Integer)

      expect(attrs).to have_key(:vintage)
      expect([true, false]).to include(attrs[:vintage])

      expect(attrs).to have_key(:img_url)
      expect(attrs[:img_url]).to be_a(String)
    end
  end

  it "returns an empty array when no posters exist" do
    get '/api/v1/posters'

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response_body[:data]).to eq([])
  end

  it "returns a single poster in the required format" do
    poster =  Poster.create(
      name: "REGRET",
      description: "Hard work rarely pays off.",
      price: 89.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )

    get "/api/v1/posters/#{poster.id}"

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)

    data = response_body[:data]

    expect(data).to have_key(:id)
    expect(data[:id]).to eq(poster.id.to_s)

    expect(data).to have_key(:type)
    expect(data[:type]).to eq("poster")

    expect(data).to have_key(:attributes)

    attrs = data[:attributes]

    expect(attrs[:name]).to eq("REGRET")
    expect(attrs[:description]).to eq("Hard work rarely pays off.")
    expect(attrs[:price]).to eq(89.00)
    expect(attrs[:year]).to eq(2018)
    expect(attrs[:vintage]).to eq(true)
    expect(attrs[:img_url]).to eq("https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
  end

  it "returns a 404 if the poster is not found" do
    get "/api/v1/posters/999999"

    expect(response.status).to eq(404)

    error_body = JSON.parse(response.body, symbolize_names: true)
    expect(error_body).to have_key(:error)
  end

  it "deletes a poster and returns a 204 error with no body" do
    poster =  Poster.create(
      name: "DELETE ME",
      description: "Will be gone.",
      price: 10.00,
      year: 2025,
      vintage: false,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )

    delete "/api/v1/posters/#{poster.id}"

    expect(response).to have_http_status(:no_content)
    expect(response.body).to be_empty
    expect(Poster.find_by(id: poster.id)).to be_nil
  end

  it "returns 404 when trying to delete a non-existent poster" do
    delete "/api/v1/posters/9999999"

    expect(response).to have_http_status(:not_found)

    error_body = JSON.parse(response.body, symbolize_names: true)
    expect(error_body).to have_key(:error)
    expect(error_body[:error]).to eq("Poster not found")
  end
end