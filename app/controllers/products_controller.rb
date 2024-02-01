class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update, :destroy, :show]
  before_action :set_suppliers, only: [:new, :edit]

  def index
    if params[:cod]
      @products = Product.where(cod: params[:cod]).order(last_price_update_date: :asc).paginate(page: params[:page], per_page: 10)
    else
      @products = Product.order(last_price_update_date: :asc, last_stock_update_date: :asc).paginate(page: params[:page], per_page: 10)
    end
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def show
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

  def finder
    @resultados = Product.finder(params[:term]).map do |product|
      {
        id: product.id,
        name: product.name,
        existence: product.existence,
      }
    end
    respond_to do |format|
      format.json { render :json => @resultados }
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
