class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update, :destroy]
  before_action :set_suppliers, only: [:new, :edit]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.create(product_params)
    respond_to do |format|
      if @product.save
        format.json { head :no_content }
        format.js
      else
        format.json { render json: @product.errors, status: :unprocessable_entity }
        format.js { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.json { head :no_content }
        format.js
      else
        format.json { render json: @product.errors, status: :unprocessable_entity }
        format.js { render :edit }
      end
    end
  end

  def destroy
    if @product.destroy
      respond_to do |format|
        format.json { head :no_content }
        format.js
      end
    end
  end

  private
  def product_params
    params.require(:product).permit(:image_product, :cod, :name, :description, :existence, :unit_cost, :selling_unit_price, :supplier_id)
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def set_suppliers
    @suppliers = Supplier.all
  end
end
