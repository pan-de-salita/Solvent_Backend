class AddCompositeIndexToSolutions < ActiveRecord::Migration[7.1]
  def change
    add_index :solutions, %i[user_id puzzle_id], name: 'index_solutions_on_user_id_and_puzzle_id'
  end
end
