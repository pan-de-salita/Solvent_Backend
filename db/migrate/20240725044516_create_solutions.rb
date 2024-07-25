class CreateSolutions < ActiveRecord::Migration[7.1]
  def change
    create_table :solutions do |t|
      t.text :source_code, default: '', null: false
      t.text :stdin, default: ''
      t.integer :iteration, null: false

      t.references :language, foreign_key: true, null: false
      t.references :puzzle, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
