class ChangeNameColumnDelinquent < ActiveRecord::Migration
  def change
    rename_column :declarations, :present_deliquent_loan, :present_delinquent_loan
  end
end
