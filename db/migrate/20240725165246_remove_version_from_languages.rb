class RemoveVersionFromLanguages < ActiveRecord::Migration[7.1]
  def change
    remove_column :languages, :version
  end
end
