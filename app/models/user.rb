class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Roles
  enum role: { analyst: 0, admin: 1, employee: 2 }

  # Associations
  has_many :sales
  has_many :purchases
  has_many :transactions
  has_many :sale_payments, through: :sales
  has_many :purchase_payments, through: :purchases

  def update_actual_balance(amount)
    raise ArgumentError, "El monto debe ser un número decimal" unless amount.is_a?(Numeric)

    ActiveRecord::Base.transaction do
      self.actual_balance += amount
      save!
    end
  end
end
