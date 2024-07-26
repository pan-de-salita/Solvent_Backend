class AddStarterCodeToPuzzles < ActiveRecord::Migration[7.1]
  def change
    Puzzle.destroy_all
    add_column :puzzles, :starter_code, :text, null: false
  end
end
