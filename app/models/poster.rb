class Poster < ApplicationRecord
  def self.sorted_by(order)
    if ["asc", "desc"].include?(order) #protect against weirdness
      order(created_at: order)
    else
      all
    end
  end

  def self.filter_by(name)
    if name.present?
      where("name ILIKE ?", "%#{name}%").order('LOWER(name) ASC')
    else
      all
    end
  end

  def self.filter_by_price(min: nil, max: nil)
    posters = all
    posters = posters.where("price >= ?", min) if min.present?
    posters = posters.where("price <= ?", max) if max.present?
    posters
  end 
end