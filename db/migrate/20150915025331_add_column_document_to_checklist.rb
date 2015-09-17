class AddColumnDocumentToChecklist < ActiveRecord::Migration
  def change
    add_column :checklists, :document, :string
  end
end
