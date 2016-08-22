class AddCoBorrowerSignPositionToLenderDocusignForm < ActiveRecord::Migration
  def change
    add_column :lender_docusign_forms, :co_borrower_sign, :string
  end
end
