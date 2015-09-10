class RemoveLateFeeTextFromLoans < ActiveRecord::Migration
  def change
    remove_column :loans, :late_fee_text
  end
end
