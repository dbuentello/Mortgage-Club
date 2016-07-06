class AddCitizenStatusToDeclarations < ActiveRecord::Migration
  def change
    add_column :declarations, :citizen_status, :string
  end
end