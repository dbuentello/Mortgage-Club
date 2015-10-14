class RemoveOriginationFeeFromLoan < ActiveRecord::Migration
  def change
    remove_column :loans, :origination_fee
  end
end
