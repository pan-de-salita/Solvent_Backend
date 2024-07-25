class ModifyNameAndVersionOfLanguages < ActiveRecord::Migration[7.1]
  def change
    Language.destroy_all
    change_column_null :languages, :name, false
    change_column_null :languages, :version, true
  end
end
