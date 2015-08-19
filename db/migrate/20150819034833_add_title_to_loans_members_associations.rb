class AddTitleToLoansMembersAssociations < ActiveRecord::Migration
  def change
    add_column :loans_members_associations, :title, :string
  end
end
