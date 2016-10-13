class AddUpdatedRateTimeToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :updated_rate_time, :datetime
  end
end
