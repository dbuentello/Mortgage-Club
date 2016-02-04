class AddRateValueToHomepageRate < ActiveRecord::Migration
  def change
    add_column :homepage_rates, :rate_value, :float
  end
end
