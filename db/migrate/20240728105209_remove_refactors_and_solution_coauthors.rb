class RemoveRefactorsAndSolutionCoauthors < ActiveRecord::Migration[7.1]
  def change
    drop_table :refactors
    drop_table :solution_coauthors
    execute 'DROP TYPE refactor_status;'
  end
end
