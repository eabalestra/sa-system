class Product < ApplicationRecord
  # Associations
  belongs_to :supplier
  has_one_attached :image_product

  # Validations
  before_create :set_last_update_dates
  before_update :update_last_price_update_date, if: :selling_unit_price_changed?
  before_update :update_last_stock_update_date, if: :existence_changed?
  before_save :calculate_selling_unit_price

  validates :cod, presence: true, uniqueness: true
  validates :name, presence: true
  validates :existence, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :unit_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :supplier_id, presence: true
  validates :profit_margin, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :iva_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Scopes
  scope :by_supplier, ->(supplier_id) { where(supplier_id: supplier_id) }

  private

  # Methods
  def update_last_price_update_date
    self.last_price_update_date = Date.today
  end

  def update_last_stock_update_date
    self.last_stock_update_date = Date.today
  end

  def set_last_update_dates
    self.last_price_update_date = Date.today
    self.last_stock_update_date = Date.today
  end

  def self.finder(term)
    Product.where('name LIKE ?', "%#{term}%")
  end

  def calculate_selling_unit_price
    self.selling_unit_price = self.unit_cost * (1 + self.profit_margin) * (1 + self.iva_amount)
  end

end
