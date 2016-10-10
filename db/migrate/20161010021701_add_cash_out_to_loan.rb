class AddCashOutToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :cash_out, :decimal, precision: 13, scale: 3
  end
end
