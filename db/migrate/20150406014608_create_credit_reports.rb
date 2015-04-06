class CreateCreditReports < ActiveRecord::Migration
  def change
    create_table :credit_reports do |t|
      t.integer  :borrower_id
      t.datetime :date
      t.integer  :score
    end

    create_table :liabilities do |t|
      t.integer :credit_report_id
      t.string  :name
      # monthly payment
      t.integer :payment
      # months remaining
      t.integer :months
      # unpaid balance
      # -999,999,999.99 to 999,999,999.99
      t.decimal :balance, :precision => 11, :scale => 2
    end

    add_column :addresses, :liability_id, :integer
    add_index :addresses, :liability_id
    add_index :credit_reports, :borrower_id
    add_index :liabilities, :credit_report_id
  end
end
