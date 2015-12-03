class AddAssociationBetweenLoanAndLender < ActiveRecord::Migration
  def change
    add_reference :loans, :lender, index: true, foreign_key: true, type: :uuid
  end
end
