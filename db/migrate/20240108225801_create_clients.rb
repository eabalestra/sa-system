class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :phone
      t.string :dir
      t.string :email
      t.string :city

      t.timestamps
    end
  end
end
