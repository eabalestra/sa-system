require 'libreconv'

class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :add_item, :destroy, :add_client, :receipt]

  # GET /sales
  def index
    if params[:id]
      @sales = Sale.where(id: params[:id]).paginate(page: params[:page], per_page: 10)
    else
      @sales = Sale.order(:payment_status, id: :desc, total_amount: :desc).paginate(page: params[:page], per_page: 10)
    end
  end

  # GET /sales/new
  def new
    @sale = current_user.sales.create(total_amount: 0.0)
    redirect_to edit_sale_path(@sale), notice: "La venta ha sido creada"
  end

  def show
  end

  # GET /sales/:id/edit
  def edit
    @sale_products = @sale.sale_details
  end

  # DELETE /sales/:id
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

  # POST /add_item_sale
  def add_item
    product = Product.find(params[:product_id])

    if product.nil?
      return render json: { message: "El producto no se encontró" }, status: :not_found
    elsif product.existence <= 0
      return render json: { message: "El producto no tiene stock" }, status: :unprocessable_entity
    elsif product.existence < params[:quantity].to_i
      return render json: { message: "No hay suficiente stock" }, status: :unprocessable_entity
    else
      quantity = params[:quantity].nil? ? 1 : params[:quantity].to_i
    end

    discount = params[:discount].nil? ? 0 : params[:discount].to_f

    product_amount = (product.selling_unit_price * quantity) - ((product.selling_unit_price * quantity) * discount)

    @sale_detail = @sale.sale_details.build(product: product, quantity: quantity, price_at_sale: product.selling_unit_price, discount: discount)

    amount_before_registration = @sale.total_amount
    amount_after_registration = amount_before_registration + product_amount

    @sale.total_amount = amount_after_registration

    existence_before_sale = product.existence

    result = {
      product_id:       @sale_detail.product_id,
      price:            product.selling_unit_price.to_f,
      name:             @sale_detail.product.try(:name),
      quantity:         @sale_detail.quantity,
      discount:         @sale_detail.discount,
      amount_item:      product.selling_unit_price * quantity,
      amount_sale:      amount_after_registration
    }

    product.existence  = existence_before_sale - quantity

    respond_to do |format|
      if @sale.save && product.save
        format.json { render json: result }
      else
        format.json { render json: @sale.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # POST /sales/add_client
  def add_client
    client = Client.find(params[:client_id])

    if client.present?
      @sale.client = client
      if @sale.valid?
        result = { name: @sale.client.try(:name) }

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

  # GET /sales/:id/receipt
  def receipt
    xlsx_content = Sale.generate_doc(@sale)
    xlsx_path = "/tmp/comprobante-de-venta-#{@sale.id}-descartables-sa.xlsx"
    File.open(xlsx_path, 'wb') { |f| f.write(xlsx_content) }

    pdf_path = "/tmp/comprobante-de-venta-#{@sale.id}-descartables-sa.pdf"
    Libreconv.convert(xlsx_path, pdf_path)

    pdf = File.read(pdf_path)
    send_data pdf, filename: "comprobante-de-venta-#{@sale.id}-descartables-sa.pdf", type: 'application/pdf', disposition: 'attachment'
  end

  private

  def set_sale
    @sale = Sale.find(params[:id])
  end
end
