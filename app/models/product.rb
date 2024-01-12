class Product < ApplicationRecord
  # Associations
  belongs_to :supplier

  # Validations
  before_create :set_last_update_dates

  private

  def set_last_update_dates
    self.last_price_update_date = Date.today
    self.last_stock_update_date = Date.today
  end
end
