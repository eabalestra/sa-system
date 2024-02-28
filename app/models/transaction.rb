class Transaction < ApplicationRecord
  belongs_to :sale_payment, optional: true, foreign_key: :sale_payments_id
  belongs_to :purchase_payment, optional: true, foreign_key: :purchase_payments_id

  belongs_to :user

  enum transaction_type: { sale_payment: 0, purchase_payment: 1, income: 2, outgoing: 3 }

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :user_id, presence: true
  validates :transaction_type, presence: true

  after_save :update_balance

  private

  def update_balance
    ActiveRecord::Base.transaction do
      balance = Balance.last
      balance = Balance.new(amount: 0) unless balance

      if self.sale_payment?
        self.user.update_actual_balance(self.amount)
        balance.amount += self.sale_payment.amount
      elsif self.income?
        self.user.update_actual_balance(self.amount)
        balance.amount += self.amount
      elsif self.purchase_payment?
        self.user.update_actual_balance(self.amount * -1)
        balance.amount -= self.purchase_payment.amount
      elsif self.outgoing?
        self.user.update_actual_balance(self.amount * -1)
        balance.amount -= self.amount
      else
        raise "Invalid transaction type"
      end

      balance.save!
    end
  end

end
