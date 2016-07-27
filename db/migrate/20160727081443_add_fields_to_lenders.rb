class AddFieldsToLenders < ActiveRecord::Migration
  def change
    add_column :lenders, :appraisal_fee, :decimal
    add_column :lenders, :tax_certification_fee, :decimal
    add_column :lenders, :flood_certification_fee, :decimal
  end
end
