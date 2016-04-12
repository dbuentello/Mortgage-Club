class CreateFredEconomic < ActiveRecord::Migration
  def change
    create_table :fred_economics do |t|
      t.datetime :event_date
      t.float :year_fixed_30
      t.float :year_fixed_15
      t.float :year_arm_5
    end
  end
end
