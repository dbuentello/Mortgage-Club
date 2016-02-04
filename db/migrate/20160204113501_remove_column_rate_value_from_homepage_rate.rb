class RemoveColumnRateValueFromHomepageRate < ActiveRecord::Migration
  def change
    remove_column :homepage_rates, :rate_value
  end
end
