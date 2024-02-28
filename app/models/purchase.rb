class Purchase < ApplicationRecord
  has_many :purchase_details, dependent: :destroy
  has_many :purchase_payments, dependent: :destroy

  belongs_to :supplier, optional: true
  belongs_to :user

  enum payment_status: { unpaid: 0, partially_paid: 1, paid: 2 }

  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates :user_id, presence: true
  validates :payment_status, presence: true

  def paid_amount()
    if not self.purchase_payments.empty?
      return self.purchase_payments.sum(:amount)
    end
  end

  def pending_amount()
    if not self.purchase_payments.empty?
      self.total_amount - self.paid_amount()
    end
    self.total_amount
  end

  def update_paid_status
    paid_amount = self.paid_amount()
    if paid_amount > 0 and paid_amount < self.total_amount
      self.update(payment_status: :partially_paid)
    elsif paid_amount == self.total_amount
      self.update(payment_status: :paid)
    else
      self.update(payment_status: :unpaid)
    end
  end

end
