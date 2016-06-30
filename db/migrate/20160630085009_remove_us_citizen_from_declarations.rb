class RemoveUsCitizenFromDeclarations < ActiveRecord::Migration
  def change
    remove_column :declarations, :us_citizen
    remove_column :declarations, :permanent_resident_alien
  end
end
