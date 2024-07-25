class AddLanguageIndexToLanguages < ActiveRecord::Migration[7.1]
  def change
    add_index :languages, :name, unique: true
  end
end
