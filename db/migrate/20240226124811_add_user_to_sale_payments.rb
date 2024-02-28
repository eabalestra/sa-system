class AddUserToSalePayments < ActiveRecord::Migration[7.1]
  def up
    # Add a reference to the sale_payments table that references the users table and allow null values
    add_reference :sale_payments, :user, null: true, foreign_key: true

    # Update the sale_payments table to set the user_id column to
    # the user_id of the sale that the sale_payment belongs to
    User.reset_column_information
    SalePayment.all.each do |sale_payment|
      sale_payment.update(user: sale_payment.sale.user)
    end

    # Change the user_id column to not allow null values
    change_column_null :sale_payments, :user_id, false
  end

  def down
    remove_reference :sale_payments, :user
  end
end
