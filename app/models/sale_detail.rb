class SaleDetail < ApplicationRecord
  # Associations
  belongs_to :product
  belongs_to :sale

  # Validations
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :product_id, presence: true
  validates :sale_id, presence: true
  validates :price_at_sale, presence: true, numericality: { greater_than: 0 }

  before_create :set_date

  private

  def set_date
    self.date = Date.today
  end
end
