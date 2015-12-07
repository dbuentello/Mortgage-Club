class AddDocumentOrderToTemplate < ActiveRecord::Migration
  def change
    add_column :templates, :document_order, :integer
  end
end
