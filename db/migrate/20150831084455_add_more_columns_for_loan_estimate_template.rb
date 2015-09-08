class AddMoreColumnsForLoanEstimateTemplate < ActiveRecord::Migration
  def change
    change_column :loans, :payment_calculation, :string
    remove_column :loans, :loan_costs_total
    remove_column :loans, :services_can_shop_total
    remove_column :loans, :services_cannot_shop_total
  end
end
