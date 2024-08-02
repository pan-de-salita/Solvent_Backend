class RemovePreferredLanguagesFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :preferred_languages
  end
end
