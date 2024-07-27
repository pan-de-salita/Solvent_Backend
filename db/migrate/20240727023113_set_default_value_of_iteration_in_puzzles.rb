class SetDefaultValueOfIterationInPuzzles < ActiveRecord::Migration[7.1]
  def change
    change_column_default :solutions, :iteration, 1
  end
end
