class AddUniqueIndexesAndNotNullToUsers < ActiveRecord::Migration[8.1]
  def change
    change_column_null :users, :email, false
    change_column_null :users, :google_uid, false
    add_index :users, :email, unique: true
    add_index :users, :google_uid, unique: true
  end
end
