class AddRateLockExpirationDateToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :rate_lock_expiration_date, :datetime
  end
end
