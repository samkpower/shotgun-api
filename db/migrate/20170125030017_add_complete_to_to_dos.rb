class AddCompleteToToDos < ActiveRecord::Migration[5.0]
  def change
    add_column :to_dos, :complete, :boolean
  end
end
