class RemoveIterationFromSolution < ActiveRecord::Migration[7.1]
  def change
    remove_column :solutions, :iteration, :integer
  end
end
