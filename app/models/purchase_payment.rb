class PurchasePayment < ApplicationRecord
  belongs_to :purchase
  has_one :purchase_transaction, class_name: 'Transaction'

  # Validations
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validates :purchase_id, presence: true
  validate :amount_not_greater_than_total_purchase

  after_save :register_payment_transaction

  private

  def register_payment_transaction
    transaction = Transaction.new(
      amount: self.amount,
      description: "Pago a proveedor#{
        if self.purchase.supplier.present?
          " "+self.purchase.supplier.name
        else
          ""
        end
      } por compra ##{self.purchase.id}",
      transaction_type: :purchase_payment,
      purchase_payment: self,
      user: self.purchase.user,
    )

    if transaction.valid?
      transaction.save
    else
      transaction.errors.full_messages.each do |message|
        errors.add(:base, message)
      end
      raise ActiveRecord::Rollback
    end
  end

  def amount_not_greater_than_total_purchase
    if self.amount.present? && self.purchase.present?
      if self.amount > self.purchase.pending_amount()
        errors.add(:base, "El monto ingresado no puede ser mayor al monto pendiente de la compra.")
      end
      if self.amount > self.purchase.total_amount
        errors.add(:base, "El monto ingresado no puede ser mayor al monto total de la compra.")
      end
    end
  end
end
