class RemoveColumnLiabilityType < ActiveRecord::Migration
  def change
    remove_column :liabilities, :liability_type
  end
end
