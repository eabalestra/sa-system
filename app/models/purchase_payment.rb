class PurchasePayment < ApplicationRecord
  belongs_to :purchase

  # Validations
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validates :purchase_id, presence: true
  validate :amount_not_greater_than_total_purchase

  def amount_not_greater_than_total_purchase
    if self.amount.present? && self.purchase.present?
      if self.amount > self.purchase.pending_amount()
        errors.add(:amount, "can't be greater than pending purchase amount")
      end
      if self.amount > self.purchase.total_amount
        errors.add(:amount, "can't be greater than total purchase amount")
      end
    end
  end
end
