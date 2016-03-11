class ChangeNmlsDataTypeToString < ActiveRecord::Migration
  def up
    change_column :loan_members, :nmls_id, :string
  end

  def down
    change_column :loan_members, :nmls_id, :integer
  end
end
