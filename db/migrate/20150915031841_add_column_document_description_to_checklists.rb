class AddColumnDocumentDescriptionToChecklists < ActiveRecord::Migration
  def change
    add_column :checklists, :document_description, :string
  end
end
