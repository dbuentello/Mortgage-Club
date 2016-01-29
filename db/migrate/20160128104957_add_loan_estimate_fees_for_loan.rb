class AddLoanEstimateFeesForLoan < ActiveRecord::Migration
  def change
    add_column :loans, :origination_charges_fees, :text
    add_column :loans, :service_cannot_shop_fees, :text
    add_column :loans, :service_can_shop_fees, :text
    add_column :loans, :tax_and_government_fees, :text
  end
end
