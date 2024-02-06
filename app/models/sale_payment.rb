class SalePayment < ApplicationRecord
  belongs_to :sale

  # Validations
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validates :sale_id, presence: true
  validate :amount_not_greater_than_total_sale

  private

  def amount_not_greater_than_total_sale
    if amount.present? && sale.present?
      if amount > sale.total_amount
        errors.add(:amount, "can't be greater than total sale amount")
      end
      if amount > sale.pending_amount
        errors.add(:amount, "can't be greater than pending sale amount")
      end
    end
  end
end
