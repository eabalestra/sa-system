class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.integer :cod
      t.string :name
      t.string :description
      t.integer :existence
      t.date :last_price_update_date
      t.date :last_stock_update_date
      t.decimal :unit_cost
      t.decimal :selling_unit_price

      t.timestamps
    end
  end
end
