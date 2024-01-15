class SaleDetail < ApplicationRecord
  belongs_to :product
  belongs_to :sale
  belongs_to :client
end
