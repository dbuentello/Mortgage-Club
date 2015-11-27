class AddIsFileTaxesJointlyToBorrowers < ActiveRecord::Migration
  def change
    add_column :borrowers, :is_file_taxes_jointly, :boolean
  end
end