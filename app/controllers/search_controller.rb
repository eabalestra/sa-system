class SearchController < ApplicationController

  def results
    @products = Product.finder(params[:term])
    @clients = Client.finder(params[:term])
    @suppliers = Supplier.finder(params[:term])
  end

end
