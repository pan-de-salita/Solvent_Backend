class RenameRelationshipColumns < ActiveRecord::Migration[7.1]
  def change
    rename_column :relationships, :followee_id, :followed_id
  end
end
