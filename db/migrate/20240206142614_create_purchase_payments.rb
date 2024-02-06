class CreatePurchasePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :purchase_payments do |t|
      t.references :purchase, null: false, foreign_key: true
      t.decimal :amount
      t.date :date

      t.timestamps
    end
  end
end
