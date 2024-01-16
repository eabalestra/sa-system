class SaleDetail < ApplicationRecord
  # Associations
  belongs_to :product
  belongs_to :sale

  before_create :set_date

  private

  def set_date
    self.date = Date.today
  end
end
