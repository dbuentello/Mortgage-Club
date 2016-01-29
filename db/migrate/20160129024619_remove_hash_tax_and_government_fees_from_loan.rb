class RemoveHashTaxAndGovernmentFeesFromLoan < ActiveRecord::Migration
  def change
    remove_column :loans, :tax_and_government_fees
  end
end
