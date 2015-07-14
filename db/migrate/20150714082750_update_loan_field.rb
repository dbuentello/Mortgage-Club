class UpdateLoanField < ActiveRecord::Migration
  def up
    change_column :loans, :interest_rate, :decimal, :precision => 9, :scale => 3
  end

  def down
    change_column :loans, :interest_rate, :decimal, :precision => 11, :scale => 2
  end
end
