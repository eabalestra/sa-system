class CreatePurchaseDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :purchase_details do |t|
      t.integer :quantity
      t.references :product, null: false, foreign_key: true
      t.references :purchase, null: false, foreign_key: true
      t.decimal :price_at_purchase

      t.timestamps
    end
  end
end
