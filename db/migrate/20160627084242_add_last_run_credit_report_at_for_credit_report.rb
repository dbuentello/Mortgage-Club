class AddLastRunCreditReportAtForCreditReport < ActiveRecord::Migration
  def change
    add_column :credit_reports, :last_run_at, :datetime
  end
end
