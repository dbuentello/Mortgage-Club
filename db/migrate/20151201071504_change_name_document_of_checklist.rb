class ChangeNameDocumentOfChecklist < ActiveRecord::Migration
  def change
    rename_column :checklists, :document, :subject_name
  end
end
