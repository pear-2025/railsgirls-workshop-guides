class AddUsernameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :username, :string
    add_index :users, :username, unique: true

    # Allow email to be blank/unrequired
    remove_index :users, :email if index_exists?(:users, :email)
    change_column_null :users, :email, true
    change_column_default :users, :email, from: "", to: nil
  end
end
