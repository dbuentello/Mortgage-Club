class AddLenderAddressToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :lender_address, :text
  end
end
