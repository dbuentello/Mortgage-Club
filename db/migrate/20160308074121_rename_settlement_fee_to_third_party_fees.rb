class RenameSettlementFeeToThirdPartyFees < ActiveRecord::Migration
  def change
    rename_column :loans, :settlement_fee, :third_party_fees
  end
end
