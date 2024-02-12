class CreateSaleDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :sale_details do |t|
      t.integer :quantity
      t.references :product, null: false, foreign_key: true
      t.references :sale, null: false, foreign_key: true
      t.decimal :price_at_sale
      t.decimal :discount

      t.timestamps
    end
  end
end
