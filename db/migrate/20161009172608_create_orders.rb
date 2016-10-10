class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name
      t.integer :bookscount
      t.string :fio
      t.string :phone
      t.integer :zipcode
      t.string :city
      t.string :address
      t.string :email
      t.string :comment
      t.string :delivery
      t.integer :price
      t.string :status

      t.timestamps null: false
    end
  end
end
