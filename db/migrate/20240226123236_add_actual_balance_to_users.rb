class AddActualBalanceToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :actual_balance, :decimal, default: 0.0
    add_index :users, :actual_balance
  end
end
