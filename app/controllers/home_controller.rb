class HomeController < ApplicationController
  SALE_PAYMENTS = 0
  PURCHASE_PAYMENTS = 1
  INCOMES = 2
  OUTGOINGS = 3

  def index
    time_now = Time.zone.now
    monthly_range = time_now.beginning_of_month..time_now.end_of_month
    annual_range = time_now.beginning_of_year..time_now.end_of_year

    monthly_incomes = Transaction.where(transaction_type: INCOMES).where(created_at: monthly_range).sum(:amount)
    monthly_incomes_for_sales = Transaction.where(transaction_type: SALE_PAYMENTS).where(created_at: monthly_range).sum(:amount)

    monthly_costs = Transaction.where(transaction_type: OUTGOINGS).where(created_at: monthly_range).sum(:amount)
    monthly_costs_for_purchases = Transaction.where(transaction_type: PURCHASE_PAYMENTS).where(created_at: monthly_range).sum(:amount)

    annual_incomes = Transaction.where(transaction_type: INCOMES).where(created_at: annual_range).sum(:amount)
    annual_incomes_for_sales = Transaction.where(transaction_type: SALE_PAYMENTS).where(created_at: annual_range).sum(:amount)

    annual_costs = Transaction.where(transaction_type: OUTGOINGS).where(created_at: annual_range).sum(:amount)
    annual_costs_for_purchases = Transaction.where(transaction_type: PURCHASE_PAYMENTS).where(created_at: annual_range).sum(:amount)

    @monthly_earnings = (monthly_incomes + monthly_incomes_for_sales) - monthly_costs - monthly_costs_for_purchases
    @annual_earnings = (annual_incomes + annual_incomes_for_sales) - annual_costs - annual_costs_for_purchases

    @monthly_costs = monthly_costs + monthly_costs_for_purchases
    @annual_costs = annual_costs + annual_costs_for_purchases

    @money_outstanding = Sale.unpaid.sum(:total_amount) + Sale.partially_paid.sum(:total_amount) - Sale.partially_paid.joins(:sale_payments).sum("sale_payments.amount")
    @money_outstading_to_pay = Purchase.unpaid.sum(:total_amount) + Purchase.partially_paid.sum(:total_amount) - Purchase.partially_paid.joins(:purchase_payments).sum("purchase_payments.amount")

    @balance = Balance.last || Balance.new(amount: 0)
    @users = User.where(role: 1)
  end
end
