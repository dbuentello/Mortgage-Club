class RenameSecondBorrowerColumn < ActiveRecord::Migration
  def change
    rename_column :loans, :second_borrower_id, :secondary_borrower_id
  end
end
