class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :cod
      t.string :name
      t.string :description
      t.integer :existence
      t.date :last_price_update_date
      t.date :last_stock_update_date
      t.decimal :unit_cost
      t.decimal :selling_unit_price
      t.string :image_product
      t.references :supplier, foreign_key: true
      t.decimal :iva_amount, precision: 8, scale: 2
      t.decimal :profit_margin, precision: 8, scale: 2

      t.timestamps
    end
  end
end
