class RemoveColumnMortgagePaymentOutOfProperty < ActiveRecord::Migration
  def change
    remove_column :properties, :mortgage_payment
  end
end
