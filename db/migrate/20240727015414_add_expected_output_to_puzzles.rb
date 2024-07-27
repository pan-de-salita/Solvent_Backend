class AddExpectedOutputToPuzzles < ActiveRecord::Migration[7.1]
  def change
    add_column :puzzles, :expected_output, :text, null: false
  end
end
