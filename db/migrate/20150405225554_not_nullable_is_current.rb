class NotNullableIsCurrent < ActiveRecord::Migration
  def change
    change_column :borrower_addresses, :is_current, :boolean, null: false, default: false
  end
end
