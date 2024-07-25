class AddCommentIndices < ActiveRecord::Migration[7.1]
  def change
    add_index :comments, %i[solution_id user_id]
  end
end
