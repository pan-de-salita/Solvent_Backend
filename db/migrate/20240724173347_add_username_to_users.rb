class AddUsernameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :username, :string
    User.all.each_with_index { |user, idx| user.update_column(:username, "test_user_#{idx}") }
    change_column_null :users, :username, false
    add_index :users, :username, unique: true
  end
end
