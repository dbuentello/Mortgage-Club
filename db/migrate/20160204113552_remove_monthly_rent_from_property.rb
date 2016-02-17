class RemoveMonthlyRentFromProperty < ActiveRecord::Migration
  def change
    remove_column :properties, :monthly_rent
  end
end
