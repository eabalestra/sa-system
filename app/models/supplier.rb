class Supplier < ApplicationRecord

  def self.finder(term)
    Supplier.where("name LIKE ?", "%#{term}%")
  end
end
