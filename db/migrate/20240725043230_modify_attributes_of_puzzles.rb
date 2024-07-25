class ModifyAttributesOfPuzzles < ActiveRecord::Migration[7.1]
  def change
    Puzzle.destroy_all

    change_table :puzzles do |t|
      t.references :language, foreign_key: true, null: false
      t.references :creator, foreign_key: { to_table: :users }, null: false
      t.string :tags, array: true, default: []

      t.remove :start_date
      t.remove :end_date
    end
  end
end
