class CreateLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :likes do |t|
      t.references :user, foreign_key: true, null: false
      t.references :solution, foreign_key: true, null: false

      t.timestamps
    end

    add_index :likes, %i[user_id solution_id], unique: true
  end
end
