class RemoveStarterCodeFromPuzzles < ActiveRecord::Migration[7.1]
  def change
    remove_column :puzzles, :starter_code, :text
  end
end
