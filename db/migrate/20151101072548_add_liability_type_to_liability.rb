class AddLiabilityTypeToLiability < ActiveRecord::Migration
  def change
    add_column :liabilities, :liability_type, :string
  end
end
