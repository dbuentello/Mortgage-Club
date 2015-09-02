class AddTimestampToSomeTables < ActiveRecord::Migration
  def change
    add_timestamps :addresses
    add_timestamps :borrower_addresses
    add_timestamps :loans
    add_timestamps :borrowers
    add_timestamps :properties
  end
end
