class AddAccountNumberToLiabilities < ActiveRecord::Migration
  def change
    add_column :liabilities, :account_number, :string
  end
end
