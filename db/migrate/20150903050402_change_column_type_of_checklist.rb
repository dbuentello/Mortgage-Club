class ChangeColumnTypeOfChecklist < ActiveRecord::Migration
  def change
    rename_column :checklists, :type, :checklist_type
  end
end
