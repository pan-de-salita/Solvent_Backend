class RenameRelationsToRelationships < ActiveRecord::Migration[7.1]
  def change
    rename_table :relations, :relationships
  end
end
