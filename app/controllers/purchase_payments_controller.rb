class PurchasePaymentsController < ApplicationController
  before_action :set_purchase, only: [:index, :new, :create]

  def index
    @payments = @purchase.purchase_payments.order(:date)
  end

  def new
    @payment = @purchase.purchase_payments.build
  end

  def create
    @payment = @purchase.purchase_payments.new(payment_params)
    @payment.date = Date.today

    respond_to do |format|
      if @payment.save
        @payment.purchase.update_paid_status
        format.json { head :no_content }
        format.js
      else
        format.json { render json: @payment.errors.full_messages, status: :unprocessable_entity }
        format.js { render :new }
      end
    end
  end

  private

  def set_purchase
    @purchase = Purchase.find(params[:purchase_id])
  end

  def payment_params
    params.require(:purchase_payment).permit(:amount)
  end
end
