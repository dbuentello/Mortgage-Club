class AddOrderDocToLenderDocusignForm < ActiveRecord::Migration
  def change
    add_column :lender_docusign_forms, :doc_order, :integer
  end
end
