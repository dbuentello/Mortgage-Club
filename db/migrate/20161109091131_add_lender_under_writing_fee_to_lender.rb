class AddLenderUnderWritingFeeToLender < ActiveRecord::Migration
  def change
    add_column :lenders, :lender_underwriting_fee, :decimal, precision: 13, scale: 3
  end
end
