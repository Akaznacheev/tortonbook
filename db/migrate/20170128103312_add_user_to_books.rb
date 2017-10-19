class AddUserToBooks < ActiveRecord::Migration[4.2]
  def change
    add_reference :books, :user, index: true, foreign_key: true
  end
end
