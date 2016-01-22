class UpdateMoneyAmountLimitationInAssetDbTable < ActiveRecord::Migration
  def up
    change_column :assets, :current_balance, :decimal, precision: 13, scale: 2
    remove_column :assets, :decimal
  end

  def down
    change_column :assets, :current_balance, :decimal, precision: 11, scale: 2
    add_column :assets, :decimal
  end
end
