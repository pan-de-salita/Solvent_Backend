class RemoveStdinFromAndAddOutputToSolutions < ActiveRecord::Migration[7.1]
  def change
    remove_column :solutions, :stdin, :text
    # add_column :solutions, :output, :text, null: false
  end
end
