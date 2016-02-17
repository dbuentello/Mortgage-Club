class AddMonthlyRentToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :monthly_rent, :float
  end
end
