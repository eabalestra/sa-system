class CreatePurchases < ActiveRecord::Migration[7.1]
  def change
    create_table :purchases do |t|
      t.decimal :total_amount
      t.references :user, foreign_key: true
      t.references :supplier, foreign_key: true
      t.integer :payment_status, default: 0

      t.timestamps
    end
  end
end
