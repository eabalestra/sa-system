class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:edit, :update, :destroy]

  def index
    @proveedores = Supplier.order(name: :asc).paginate(page: params[:page], per_page: 10)
  end

  # GET /suppliers/new
  def new
    @proveedor = Supplier.new
  end

  def edit
  end

  # POST /suppliers
  def create
    @proveedor = Supplier.new(supplier_params)

    respond_to do |format|
      if @proveedor.save
        format.json { head :no_content }
        format.js
      else
        format.json { render json: @proveedor.errors.full_messages, status: :unprocessable_entity }
        format.js { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @proveedor.update(supplier_params)
        format.json { head :no_content }
        format.js
      else
        format.json { render json: @proveedor.errors.full_messages, status: :unprocessable_entity }
        format.js { render :edit }
      end
    end
  end

  def destroy
    @proveedor.destroy
    respond_to do |format|
      format.json { head :no_content }
      format.js
    end
  end

  def finder
    @results = Supplier.finder(params[:term]).map do |supplier|
      {
        id: supplier.id,
        name: supplier.name
      }
    end

    respond_to do |format|
      format.json { render :json => @results }
    end
  end

  private

  def set_supplier
    @proveedor = Supplier.find(params[:id])
  end

  def supplier_params
    params.require(:supplier).permit(:name, :dir, :phone)
  end

end
