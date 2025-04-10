class Poster < ApplicationRecord
  def self.sorted_by(order)
    if ["asc", "desc"].include?(order) #protect against weirdness
      order(created_at: order)
    else
      all
    end
  end
end