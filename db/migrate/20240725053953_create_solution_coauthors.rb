class CreateSolutionCoauthors < ActiveRecord::Migration[7.1]
  def change
    create_table :solution_coauthors do |t|
      t.references :user, foreign_key: true, null: false
      t.references :solution, foreign_key: true, null: false

      t.timestamps
    end

    add_index :solution_coauthors, %i[user_id solution_id], unique: true
  end
end
