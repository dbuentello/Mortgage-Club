class ChangeSizeAmountMoneyInPropety < ActiveRecord::Migration
  def up
    change_column :properties, :gross_rental_income, :decimal, precision: 13, scale: 2
    change_column :properties, :estimated_property_tax, :decimal, precision: 13, scale: 2
    change_column :properties, :estimated_hazard_insurance, :decimal, precision: 13, scale: 2
    change_column :properties, :estimated_mortgage_insurance, :decimal, precision: 13, scale: 2
    change_column :properties, :hoa_due, :decimal, precision: 13, scale: 2
  end

  def down
    change_column :properties, :gross_rental_income, :decimal, precision: 11, scale: 2
    change_column :properties, :estimated_property_tax, :decimal, precision: 11, scale: 2
    change_column :properties, :estimated_hazard_insurance, :decimal, precision: 11, scale: 2
    change_column :properties, :estimated_mortgage_insurance, :decimal, precision: 11, scale: 2
    change_column :properties, :hoa_due, :decimal, precision: 11, scale: 2
  end
end
