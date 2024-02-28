class Balance < ApplicationRecord
  has_many :transactions

  validates :amount, presence: true
end
