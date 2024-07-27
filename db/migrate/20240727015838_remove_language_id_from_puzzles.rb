class RemoveLanguageIdFromPuzzles < ActiveRecord::Migration[7.1]
  def change
    remove_index :puzzles, :language_id

    remove_column :puzzles, :language_id, :bigint
  end
end
