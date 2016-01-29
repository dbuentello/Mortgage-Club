class RemoveNameFromPotentialUser < ActiveRecord::Migration
  def change
    remove_column :potential_users, :name
  end
end
