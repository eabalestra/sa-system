class CreateSalePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :sale_payments do |t|
      t.references :sale, null: false, foreign_key: true
      t.decimal :amount, null: false
      t.datetime :date, null: false

      t.timestamps
    end
  end
end
