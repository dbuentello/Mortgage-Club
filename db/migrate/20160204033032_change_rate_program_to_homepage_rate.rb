class ChangeRateProgramToHomepageRate < ActiveRecord::Migration
  def up
    rename_table :rate_programs, :homepage_rates
  end
  def down
    rename_table :homepage_rates, :rate_programs
  end
end
