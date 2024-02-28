class AddUserToPurchasePayments < ActiveRecord::Migration[7.1]
  def up
    # Add a reference to the purchase_payments table that references the users table and allow null values
    add_reference :purchase_payments, :user, null: true, foreign_key: true

    # Update the purchase_payments table to set the user_id column to the user_id of the purchase
    # that the purchase_payment belongs to
    User.reset_column_information
    PurchasePayment.all.each do |purchase_payment|
      purchase_payment.update(user: purchase_payment.purchase.user)
    end

    # Change the user_id column to not allow null values
    change_column_null :purchase_payments, :user_id, false
  end

  def down
    remove_reference :purchase_payments, :user
  end
end
