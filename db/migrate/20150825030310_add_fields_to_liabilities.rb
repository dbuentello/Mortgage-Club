class AddFieldsToLiabilities < ActiveRecord::Migration
  def change
    add_column :liabilities, :account_type, :string
    add_column :liabilities, :phone, :string

    change_column :liabilities, :payment, :decimal, :precision => 11, :scale => 2
  end
end
