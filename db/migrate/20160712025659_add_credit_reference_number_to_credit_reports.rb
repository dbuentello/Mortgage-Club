class AddCreditReferenceNumberToCreditReports < ActiveRecord::Migration
  def change
    add_column :credit_reports, :credit_reference_number, :string
  end
end
