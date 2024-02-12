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
    transaction = Transaction.new(
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

    if transaction.valid?
      transaction.save notice: "Payment transaction was successfully created."
    else
      transaction.errors.full_messages.each do |message|
        errors.add(:base, message)
      end
      raise ActiveRecord::Rollback
    end
  end

  def amount_not_greater_than_total_sale
    if amount.present? && sale.present?
      if amount > sale.total_amount
        errors.add(:amount, "El monto ingresado no puede ser mayor al monto total de la venta.")
      end
      if amount > sale.pending_amount
        errors.add(:amount, "El monto ingresado no puede ser mayor al monto pendiente de la venta.")
      end
    end
  end
end
