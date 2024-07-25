class ReaddVersionToLanguages < ActiveRecord::Migration[7.1]
  def change
    add_column :languages, :version, :string
  end
end
