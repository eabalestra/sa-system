class SalePaymentsController < ApplicationController
  before_action :set_sale, only: [:new, :create]

  def new
    @payment = @sale.sale_payments.build
  end

  def create
    @payment = @sale.sale_payments.new(payment_params)
    @payment.date = Date.today

    respond_to do |format|
      if @payment.save
        format.json { head :no_content }
        format.js
      else
        format.json { render json: @payment.errors.full_messages, status: :unprocessable_entity }
        format.js { render :new }
      end
    end

  end

  private

  def set_sale
    @sale = Sale.find(params[:sale_id])
  end

  def payment_params
    params.require(:sale_payment).permit(:amount)
  end
end
