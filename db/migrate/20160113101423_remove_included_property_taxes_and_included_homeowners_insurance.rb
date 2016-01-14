class RemoveIncludedPropertyTaxesAndIncludedHomeownersInsurance < ActiveRecord::Migration
  def change
    remove_column :loans, :included_property_taxes
    remove_column :loans, :included_homeowners_insurance
  end
end
