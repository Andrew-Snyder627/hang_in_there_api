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

  describe ".filter_by" do
    before :each do
      @poster1 = Poster.create(name: "REGRET", 
        description: "Hard work rarely pays off.",
        price: 89.00,
        year: 2018,
        vintage: true,
        img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")

      @poster2 = Poster.create(name: "FAILURE",
        description: "Why bother trying? It's probably not worth it.",
        price: 68.00,
        year: 2019,
        vintage: true,
        img_url: "https://img.industryweek.com/files/base/ebm/industryweek/image/2023/04/failure.6441a1c52787e.png?auto=format,compress&fit=crop&q=45&h=356&height=356&w=640&width=640")
          
      @poster3 = Poster.create(name: "MEDIOCRITY",
        description: "Dreams are just that—dreams.",
        price: 127.00,
        year: 2021,
        vintage: false,
        img_url: "https://miro.medium.com/v2/resize:fit:1400/1*xNps4qRlyJBVGnfJm3KvUw.jpeg")

      @poster4 = Poster.create(name: "TERRIBLE",
        description: "It's too awful to look at.",
        price: 15.00,
        year: 2022,
        vintage: true,
        img_url: "https://unsplash.com/photos/low-angle-of-hacker-installing-malicious-software-on-data-center-servers-using-laptop-9nk2antk4Bw")
      
      @poster5 = Poster.create(name: "DISASTER",
        description: "It's a mess and you haven't even started yet.",
        price: 28.00,
        year: 2016,
        vintage: false,
        img_url:  "https://images.unsplash.com/photo-1485617359743-4dc5d2e53c89")
      end

      it "filters posters with case-insensitive name match alphabetically" do
        result = Poster.filter_by("ter")

        expect(result).to eq([@poster5, @poster4])
      end

      it "returns all posters if name filter is nil" do
        result = Poster.filter_by(nil)

        expect(result.count).to eq(5)
      end

      it "returns an empty array if no match is found" do
        result = Poster.filter_by("abc")

        expect(result).to be_empty
      end

      it "filters posters based on max price" do
        result = Poster.filter_by_price(max:70.00)

        expect(result).to contain_exactly(@poster2, @poster4, @poster5) 
      end

      it "filters posters based on min price" do
        result = Poster.filter_by_price(min:80.00)

        expect(result).to contain_exactly(@poster1, @poster3) 
      end

      it "returns all posters if price filters are nil" do
        result = Poster.filter_by_price
    
        expect(result.count).to eq(5)
      end

      it "returns an empty array if no match is found" do
        result = Poster.filter_by_price(max:1.00)

        expect(result).to be_empty

        result = Poster.filter_by_price(min:1000.00)

        expect(result).to be_empty
      end
   end
end