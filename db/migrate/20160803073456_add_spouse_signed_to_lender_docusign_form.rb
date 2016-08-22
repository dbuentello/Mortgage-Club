class AddSpouseSignedToLenderDocusignForm < ActiveRecord::Migration
  def change
    add_column :lender_docusign_forms, :spouse_signed, :boolean
  end
end
