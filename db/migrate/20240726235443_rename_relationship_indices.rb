class RenameRelationshipIndices < ActiveRecord::Migration[7.1]
  def change
    drop_table :relationships

    create_table :relationships do |t|
      t.references :follower, foreign_key: { to_table: :users }, null: false
      t.references :followed, foreign_key: { to_table: :users }, null: false

      t.timestamps
    end

    add_index :relationships, %i[follower_id followed_id], unique: true
  end
end
