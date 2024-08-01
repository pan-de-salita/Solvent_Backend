class RenameSolutionLikeToLike < ActiveRecord::Migration[7.1]
  def change
    rename_table :solution_likes, :likes
  end
end
