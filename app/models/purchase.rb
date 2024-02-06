class Purchase < ApplicationRecord
  has_many :purchase_details, dependent: :destroy

  belongs_to :supplier, optional: true
  belongs_to :user


end
