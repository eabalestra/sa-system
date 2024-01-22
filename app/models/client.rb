class Client < ApplicationRecord
  has_many :sales, class_name: "sales", foreign_key: "reference_id"

  def self.finder(term)
    Client.where('name LIKE ?', "%#{term}%")
  end
end
