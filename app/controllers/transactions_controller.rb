class TransactionsController < ApplicationController
  before_action :set_transactions_types, only: [:new, :create]

  def index
    if params[:id]
      @transactions = Transaction.where(id: params[:id]).paginate(page: params[:page], per_page: 10)
    else
      @transactions = Transaction.order(id: :desc, created_at: :desc).paginate(page: params[:page], per_page: 10)
    end
  end

  def new
    @transaction = current_user.transactions.new
  end

  def create
    @transaction = current_user.transactions.new(transaction_params)
    respond_to do |format|
      if @transaction.save
        format.json { head :no_content }
        format.js
      else
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
        format.js { render :new }
      end
    end
  end

  def transaction_params
    params.require(:transaction).permit(:amount, :description, :transaction_type)
  end

  def set_transactions_types
    @transactions_type = [["Ingreso", "income"], ["Egreso", "outgoing"]]
  end
end
