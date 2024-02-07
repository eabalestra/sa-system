class HomeController < ApplicationController
  def index
    monthly_sales = Sale.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month)
    @monthly_earnings = SalePayment.where(sale: monthly_sales).sum(:amount)

    monthly_costs = Purchase.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month)
    @monthly_costs = PurchasePayment.where(purchase: monthly_costs).sum(:amount)

    annual_sales = Sale.where(created_at: Time.now.beginning_of_year..Time.now.end_of_year)
    @annual_earnings = SalePayment.where(sale: annual_sales).sum(:amount)

    annual_costs = Purchase.where(created_at: Time.now.beginning_of_year..Time.now.end_of_year)
    @annual_costs = PurchasePayment.where(purchase: annual_costs).sum(:amount)

    @money_outstanding = Sale.unpaid.sum(:total_amount) + Sale.partially_paid.sum(:total_amount) - Sale.partially_paid.joins(:sale_payments).sum('sale_payments.amount')
    @money_outstading_to_pay = Purchase.unpaid.sum(:total_amount) + Purchase.partially_paid.sum(:total_amount) - Purchase.partially_paid.joins(:purchase_payments).sum('purchase_payments.amount')
  end
end
