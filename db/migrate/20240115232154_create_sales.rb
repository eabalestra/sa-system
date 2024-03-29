class CreateSales < ActiveRecord::Migration[7.1]
  def change
    create_table :sales do |t|
      t.decimal :total_amount
      t.references :user, foreign_key: true
      t.references :client, foreign_key: true
      t.integer :payment_status, default: 0

      t.timestamps
    end
  end
end
