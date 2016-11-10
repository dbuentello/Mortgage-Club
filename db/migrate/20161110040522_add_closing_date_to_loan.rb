class AddClosingDateToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :closing_date, :datetime
  end
end
