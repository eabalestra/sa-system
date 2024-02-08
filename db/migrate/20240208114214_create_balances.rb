class CreateBalances < ActiveRecord::Migration[7.1]
  def change
    create_table :balances do |t|
      t.decimal :amount

      t.timestamps
    end
  end
end
