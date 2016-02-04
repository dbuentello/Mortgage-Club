class RemoveEscrowColumnsInLoan < ActiveRecord::Migration
  def change
    remove_column :loans, :in_escrow_property_taxes
    remove_column :loans, :in_escrow_homeowners_insurance
    remove_column :loans, :in_escrow_other
  end
end
