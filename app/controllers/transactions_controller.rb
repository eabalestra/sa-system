class TransactionsController < ApplicationController

  def index
    if params[:id]
      @transactions = Transaction.where(id: params[:id]).paginate(page: params[:page], per_page: 10)
    else
      @transactions = Transaction.order(id: :desc, created_at: :desc).paginate(page: params[:page], per_page: 10)
    end
  end

end
