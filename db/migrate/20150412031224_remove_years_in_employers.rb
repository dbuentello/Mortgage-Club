class RemoveYearsInEmployers < ActiveRecord::Migration
  def change
    rename_table :borrower_employers, :employments
    remove_column :employments, :years_at_employer
    rename_column :employments, :months_at_employer, :duration
    rename_column :addresses, :borrower_employer_id, :employment_id
  end
end
