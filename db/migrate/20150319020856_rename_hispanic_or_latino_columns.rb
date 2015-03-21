class RenameHispanicOrLatinoColumns < ActiveRecord::Migration
  def change
    rename_table :borrower_government_monitoring_info, :borrower_government_monitoring_infos
    rename_column :borrower_government_monitoring_infos, :hispanic_or_latino, :is_hispanic_or_latino
  end
end
