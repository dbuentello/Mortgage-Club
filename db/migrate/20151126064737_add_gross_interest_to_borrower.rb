class AddGrossInterestToBorrower < ActiveRecord::Migration
  def change
    add_column :borrowers, :gross_interest, :decimal, :precision => 11, :scale => 2
  end
end
