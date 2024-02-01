class HomeController < ApplicationController
  def index
    monthly_sales = Sale.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month)
    @monthly_earnings = SalePayment.where(sale: monthly_sales).sum(:amount)

    annual_sales = Sale.where(created_at: Time.now.beginning_of_year..Time.now.end_of_year)
    @annual_earnings = SalePayment.where(sale: annual_sales).sum(:amount)

    @money_outstanding = Sale.unpaid.sum(:total_amount) + Sale.partially_paid.sum(:total_amount) - Sale.partially_paid.joins(:sale_payments).sum('sale_payments.amount')
  end
end
