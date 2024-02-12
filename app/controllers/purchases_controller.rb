class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :add_item, :destroy, :add_supplier]

  # GET /purchases
  def index
    if params[:id]
      @purchases = Purchase.where(id: params[:id]).paginate(page: params[:page], per_page: 10)
    else
      @purchases = Purchase.order(:payment_status, id: :desc, total_amount: :desc).paginate(page: params[:page], per_page: 10)
    end
  end

  def new
    @purchase = current_user.purchases.create(total_amount: 0.0)
    redirect_to edit_purchase_path(@purchase), notice: "La compra ha sido creada"
  end

  def show
  end

  def edit
    @purchase_products = @purchase.purchase_details
  end

  def destroy
    ActiveRecord::Base.transaction do
      @purchase.purchase_details.map do |detail|
        prod_comprado = Product.find(detail.product_id)
        prod_comprado.existence -= detail.quantity
        ActiveRecord::Rollback unless prod_comprado.save
      end

      ActiveRecord::Rollback unless @purchase.destroy
    end

    respond_to do |format|
      format.html { redirect_to purchases_url, notice: "La compra ha sido eliminada" }
      format.json { head :no_content }
    end
  end

  def add_item
    product = Product.find(params[:product_id])

    if product.nil?
      return render json: { message: "El producto no se encontró" }, status: :not_found
    else
      quantity = params[:quantity].nil? ? 1 : params[:quantity].to_i
    end

    product.unit_cost = params[:unit_cost]

    product_amount = product.unit_cost * quantity

    @purchase_detail = @purchase.purchase_details.build(product: product, quantity: quantity, price_at_purchase: product.unit_cost)

    amount_before_registration = @purchase.total_amount
    amount_after_registration = amount_before_registration + product_amount

    @purchase.total_amount = amount_after_registration

    existence_before_purchase = product.existence

    result = {
      product_id: @purchase_detail.product.id,
      price_at_purchase: product.unit_cost.to_f,
      name: @purchase_detail.product.try(:name),
      quantity: @purchase_detail.quantity,
      amount_item: product.unit_cost * quantity,
      amount_purchase: amount_after_registration
    }

    product.existence = existence_before_purchase + quantity

    respond_to do |format|
      if @purchase.save && product.save
        format.json { render json: result }
      else
        format.json { render json: @purchase_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_supplier
    supplier = Supplier.find(params[:supplier_id])
    if supplier.present?
      @purchase.supplier = supplier
      if @purchase.valid?
        result = { supplier_name: @purchase.supplier.try(:name) }

        respond_to do |format|
          if @purchase.save
            format.json { render json: result }
          else
            format.json { render json: @purchase.errors.full_messages, status: :unprocessable_entity }
          end
        end
      end
    else
      render json: { message: "El proveedor no se encontró" }, status: :not_found
    end
  end

  private

  def set_purchase
    @purchase = Purchase.find(params[:id])
  end

end
