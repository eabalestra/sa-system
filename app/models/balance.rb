class Balance < ApplicationRecord
  has_many :transactions

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
