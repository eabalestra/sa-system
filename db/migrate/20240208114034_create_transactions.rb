class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.string :description
      t.integer :transaction_type
      t.references :sale_payments, foreign_key: true
      t.references :purchase_payments, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :balance, foreign_key: true

      t.timestamps
    end
  end
end
