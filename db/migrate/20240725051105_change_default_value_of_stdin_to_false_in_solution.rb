class ChangeDefaultValueOfStdinToFalseInSolution < ActiveRecord::Migration[7.1]
  def change
    change_column_default :solutions, :stdin, from: '', to: nil
  end
end
