class AddPreferredLanguagesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :preferred_languages, :integer, array: true, default: []
  end
end
