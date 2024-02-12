class HomeController < ApplicationController
  def index
    time_now = Time.zone.now
    monthly_range = time_now.beginning_of_month..time_now.end_of_month
    annual_range = time_now.beginning_of_year..time_now.end_of_year

    @monthly_earnings = SalePayment.joins(:sale).where(sales: { created_at: monthly_range }).sum(:amount)
    @monthly_costs = PurchasePayment.joins(:purchase).where(purchases: { created_at: monthly_range }).sum(:amount)

    @annual_earnings = SalePayment.joins(:sale).where(sales: { created_at: annual_range }).sum(:amount)
    @annual_costs = PurchasePayment.joins(:purchase).where(purchases: { created_at: annual_range }).sum(:amount)

    @money_outstanding = Sale.unpaid.sum(:total_amount) + Sale.partially_paid.sum(:total_amount) - Sale.partially_paid.joins(:sale_payments).sum('sale_payments.amount')
    @money_outstading_to_pay = Purchase.unpaid.sum(:total_amount) + Purchase.partially_paid.sum(:total_amount) - Purchase.partially_paid.joins(:purchase_payments).sum('purchase_payments.amount')

    @balance = Balance.last || Balance.new(amount: 0)
  end
end
