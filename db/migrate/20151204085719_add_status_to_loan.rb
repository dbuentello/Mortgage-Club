class AddStatusToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :status, :integer, default: 0
  end
end
