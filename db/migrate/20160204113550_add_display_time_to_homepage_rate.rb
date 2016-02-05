class AddDisplayTimeToHomepageRate < ActiveRecord::Migration
  def change
    add_column :homepage_rates, :display_time, :datetime
  end
end
