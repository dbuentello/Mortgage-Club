class RenameStateColumn < ActiveRecord::Migration
  def change
    rename_column :addresses, :state, :state_type
  end
end
