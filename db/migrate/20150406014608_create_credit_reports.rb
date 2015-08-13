class CreateCreditReports < ActiveRecord::Migration
  def change
    create_table :credit_reports, id: :uuid do |t|
      t.uuid     :borrower_id, index: true
      t.datetime :date
      t.integer  :score
    end

    create_table :liabilities, id: :uuid do |t|
      t.uuid    :credit_report_id, index: true
      t.string  :name
      # monthly payment
      t.integer :payment
      # months remaining
      t.integer :months
      # unpaid balance
      # -999,999,999.99 to 999,999,999.99
      t.decimal :balance, :precision => 11, :scale => 2
    end

    add_column :addresses, :liability_id, :uuid, index: true
  end
end
