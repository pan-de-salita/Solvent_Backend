class ChangeVersionToNullableInLanguages < ActiveRecord::Migration[7.1]
  def change
    change_column_null :languages, :name, true
  end
end
