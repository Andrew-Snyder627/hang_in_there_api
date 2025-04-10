require 'rails_helper'

RSpec.describe Poster, type: :model do
  describe ".sorted_by" do
    before :each do
      @poster1 = Poster.create!(name: "First", description: "Oldest", price: 10, year: 2020, vintage: false, img_url: "url", created_at: 3.days.ago)
      @poster2 = Poster.create!(name: "Second", description: "Middle", price: 20, year: 2021, vintage: true, img_url: "url", created_at: 2.days.ago)
      @poster3 = Poster.create!(name: "Third", description: "Newest", price: 30, year: 2022, vintage: false, img_url: "url", created_at: 1.day.ago)
    end

    it "returns posters in ascending order with asc param" do
      result = Poster.sorted_by("asc")

      expect(result).to eq([@poster1, @poster2, @poster3])
    end

    it "returns posters in descending order with desc param" do
      result = Poster.sorted_by("desc")

      expect(result).to eq([@poster3, @poster2, @poster1])
    end

    it "returns all posters unsorted with invalid sort param" do
      result = Poster.sorted_by("pickle")

      expect(result).to include(@poster1, @poster2, @poster3)
      expect(result.count).to eq(3)
    end
  end
end