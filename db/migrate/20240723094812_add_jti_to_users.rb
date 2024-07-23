class AddJtiToUsers < ActiveRecord::Migration[7.1]
  def change
    # If no user records:
    # add_column :users, :jti, :string, null: false
    # add_index :users, unique: true

    # If user records already present:
    add_column :users, :jti, :string
    User.all.each { |user| user.update_column(:jti, SecureRandom.uuid) }
    change_column_null :users, :jti, false
    add_index :users, :jti, unique: true
  end
end
