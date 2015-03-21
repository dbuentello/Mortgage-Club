class RenameImpoundAccountColumn < ActiveRecord::Migration
  def change
    rename_column :properties, :impound_account, :is_impound_account
  end
end
