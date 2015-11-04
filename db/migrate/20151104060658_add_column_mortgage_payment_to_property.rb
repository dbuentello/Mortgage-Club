class AddColumnMortgagePaymentToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :mortgage_payment, :decimal, :precision => 11, :scale => 2, default: 0.00
  end
end
