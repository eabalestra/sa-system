class HomeController < ApplicationController
  def index
    monthly_sales = Sale.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month)
    @monthly_earnings = monthly_sales.sum(:total_amount)

    annual_sales = Sale.where(created_at: Time.now.beginning_of_year..Time.now.end_of_year)
    @annual_earnings = annual_sales.sum(:total_amount)

    # @money_outstanding
  end
end
