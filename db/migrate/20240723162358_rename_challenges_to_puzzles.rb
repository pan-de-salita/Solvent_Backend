class RenameChallengesToPuzzles < ActiveRecord::Migration[7.1]
  def change
    rename_table :challenges, :puzzles
  end
end
