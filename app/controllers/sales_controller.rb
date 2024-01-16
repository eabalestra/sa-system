class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :add_item, :destroy, :add_cliente]

  def index
    @sales = Sale.all
  end

  def new
    @sale = current_user.sales.create(total_amount: 0.0)
    redirect_to edit_sale_path(@sale)
  end

  def show
  end

  def edit
    @productos_venta = @sale.sale_details
  end

  def destroy
    ActiveRecord::Base.transaction do
      @sale.sale_details.map do |detail|
        prod_vendido = Product.find(detail.product_id)
        prod_vendido.existence += detail.quantity
        ActiveRecord::Rollback unless prod_vendido.save
      end

      ActiveRecord::Rollback unless @sale.destroy
    end

    respond_to do |format|
      format.html { redirect_to sales_url, notice: "La venta ha sido eliminada" }
      format.json { head :no_content }
    end
  end

  def add_item
    producto = Product.find(params[:producto_id])
    cantidad = params[:quantity].nil? ? 1 : params[:quantity].to_i

    importe_producto = producto.selling_unit_price * cantidad

    @sale_detail = @sale.sale_details.build(product: producto, quantity: cantidad)

    importe_antes_de_registro = @sale.total_amount
    importe_despues_registro = importe_antes_de_registro + importe_producto

    @sale.total_amount = importe_despues_registro

    existencia_antes_venta = producto.existence

    result = {
      product_id:      @sale_detail.product_id,
      precio_producto: producto.selling_unit_price.to_f,
      nombre_prod:     @sale_detail.product.try(:name),
      cantidad:        @sale_detail.quantity,
      importe_item:    producto.precio * cantidad,
      importe_venta:   importe_despues_registro
    }

    producto.existence  = existencia_antes_venta - cantidad

    respond_to do |format|
      if @sale.save && producto.save
        format.json { render json: result }
      else
        format.json { render json: @sale.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def add_cliente
    cliente = Client.find(params[:cliente_id])
    if cliente.present?
      @sale.client = cliente
      if @sale.valid?
        result = { nombre_cliente: @sale.client.try(:name) }

        respond_to do |format|
          if @sale.save
            format.json { render json: result }
          else
            format.json { render json: @sale.errors.full_messages, status: :unprocessable_entity }
          end
        end
      end
    else
      render json: { message: "El cliente no se encontró" }, status: :not_found
    end
  end

  private

  def set_sale
    @sale = Sale.find(params[:id])
  end
end
