class HomeController < ApplicationController
  def index
    monthly_sales = Sale.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month)
    @monthly_earnings = monthly_sales.where(paid: true).sum(:total_amount)

    annual_sales = Sale.where(created_at: Time.now.beginning_of_year..Time.now.end_of_year)
    @annual_earnings = annual_sales.where(paid: true).sum(:total_amount)

    @money_outstanding = Sale.where(paid: false).sum(:total_amount)
  end
end
