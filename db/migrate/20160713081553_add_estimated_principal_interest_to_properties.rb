class AddEstimatedPrincipalInterestToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :estimated_principal_interest, :decimal
  end
end
