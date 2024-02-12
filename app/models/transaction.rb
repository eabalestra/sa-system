class Transaction < ApplicationRecord
  belongs_to :sale_payment, optional: true, foreign_key: 'sale_payments_id'
  belongs_to :purchase_payment, optional: true, foreign_key: 'purchase_payments_id'
  belongs_to :user

  enum transaction_type: { sale_payment: 0, purchase_payment: 1, income: 2, outgoing: 3 }

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :user_id, presence: true
  validates :transaction_type, presence: true
  validate :check_balance

  after_commit :update_balance

  private

  def check_balance
    balance = Balance.last || Balance.create!(amount: 0)

    if self.purchase_payment? or self.outgoing?
      errors.add(:amount, "El monto de la transacción supera el saldo disponible en su cuenta.") if self.amount > balance.amount
    end
  end

  def update_balance
    balance = Balance.last || Balance.create!(amount: 0)

    if self.sale_payment?
      balance.amount += self.sale_payment.amount
    elsif self.income?
      balance.amount += self.amount
    elsif self.purchase_payment?
      balance.amount -= self.purchase_payment.amount
    elsif self.outgoing?
      balance.amount -= self.amount
    else
      raise "Invalid transaction type"
    end
    balance.save
    self.balance_id = balance.id
  end

end
