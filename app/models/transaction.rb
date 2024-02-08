class Transaction < ApplicationRecord
  belongs_to :sale_payment, optional: true, foreign_key: 'sale_payments_id'
  belongs_to :purchase_payment, optional: true, foreign_key: 'purchase_payments_id'
  belongs_to :user

  enum transaction_type: { sale_payment: 0, purchase_payment: 1, income: 2, outgoing: 3 }

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :user_id, presence: true
  validates :transaction_type, presence: true

  before_save :update_balance

  private

  def update_balance
    balance = Balance.last || Balance.create!(amount: 0)
    if self.sale_payment? || self.income?
      balance.amount += self.sale_payment.amount
    elsif self.purchase_payment? || self.outgoing?
      balance.amount -= self.purchase_payment.amount
    end
    balance.save
    self.balance_id = balance.id
  end

end
