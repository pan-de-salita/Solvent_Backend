class CreateRefactors < ActiveRecord::Migration[7.1]
  def change
    create_table :refactors do |t|
      t.text :source_code, default: '', null: false
      t.text :description, default: '', null: false
      t.boolean :accepted?, default: false, null: false

      t.references :solution, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
