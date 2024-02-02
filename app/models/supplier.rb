class Supplier < ApplicationRecord

  # Associations
  has_many :products

  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :dir, presence: true, length: { minimum: 5, maximum: 200 }
  validates :phone, presence: true, length: { minimum: 7, maximum: 20 }
  # validates :email, presence: true, length: { maximum: 255 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  # validates :city, presence: true, length: { minimum: 2, maximum: 100 }
  # validates :web, presence: true, length: { minimum: 5, maximum: 200 }

  # Methods
  def self.finder(term)
    Supplier.where("name LIKE ?", "%#{term}%")
  end
end
