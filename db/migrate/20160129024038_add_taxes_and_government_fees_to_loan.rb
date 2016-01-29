class AddTaxesAndGovernmentFeesToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :recording_fees_and_other_taxes, :decimal, :precision => 13, :scale => 2
    add_column :loans, :transfer_taxes, :decimal, :precision => 13, :scale => 2
  end
end
