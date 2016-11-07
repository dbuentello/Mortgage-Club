class AddIsRateLockedToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :is_rate_locked, :boolean
  end
end
