class ModifyColumnsOfPuzzleFavorites < ActiveRecord::Migration[7.1]
  def change
    drop_table :puzzle_favorites

    create_table :puzzle_favorites do |t|
      t.references :user, foreign_key: true, null: false
      t.references :puzzle, foreign_key: true, null: false

      t.timestamps
    end

    add_index :puzzle_favorites, %i[user_id puzzle_id], unique: true
  end
end
