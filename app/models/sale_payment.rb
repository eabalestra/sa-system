class SalePayment < ApplicationRecord
  belongs_to :sale
  has_one :payment_transaction, class_name: 'Transaction'

  # Validations
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validates :sale_id, presence: true
  validate :amount_not_greater_than_total_sale

  after_save :register_payment_transaction

  private

  def register_payment_transaction
    transaction = Transaction.create!(
      amount: self.amount,
      description: "Cobro a cliente#{
        if self.sale.client.present?
          " "+self.sale.client.name
        else
          ""
        end
      } por venta ##{self.sale.id}",
      transaction_type: :sale_payment,
      sale_payment: self,
      user: self.sale.user,
    )
    if transaction.errors.any?
      errors.add(:base, "Error creating transaction: #{transaction.errors.full_messages.join(', ')}")
      raise ActiveRecord::Rollback
    end
  end

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
