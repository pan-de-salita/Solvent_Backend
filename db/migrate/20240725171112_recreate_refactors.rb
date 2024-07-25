class RecreateRefactors < ActiveRecord::Migration[7.1]
  def change
    drop_table :refactors

    create_enum :refactor_status, %w[pending approved rejected]

    create_table :refactors do |t|
      t.enum :status, enum_type: 'refactor_status', null: false, default: 'pending'
      t.text :source_code, default: '', null: false
      t.text :description, default: '', null: false

      t.references :solution, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
