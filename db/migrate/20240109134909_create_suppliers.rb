class CreateSuppliers < ActiveRecord::Migration[7.1]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :phone
      t.string :dir
      t.string :email
      t.string :city
      t.string :website

      t.timestamps
    end
  end
end
