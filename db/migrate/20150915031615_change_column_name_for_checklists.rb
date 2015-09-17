class ChangeColumnNameForChecklists < ActiveRecord::Migration
  def change
    rename_column :checklists, :description, :info
  end
end
