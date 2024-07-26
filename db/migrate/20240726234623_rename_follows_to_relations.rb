class RenameFollowsToRelations < ActiveRecord::Migration[7.1]
  def change
    rename_table :follows, :relations
  end
end
