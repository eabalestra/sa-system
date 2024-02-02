class Client < ApplicationRecord
  has_many :sales

  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :dir, presence: true, length: { minimum: 5, maximum: 200 }
  validates :phone, presence: true, length: { minimum: 7, maximum: 20 }
  # validates :email, presence: true, length: { maximum: 255 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  # validates :city, presence: true, length: { minimum: 2, maximum: 100 }

  # Methods

  def self.finder(term)
    Client.where('name LIKE ?', "%#{term}%")
  end
end
