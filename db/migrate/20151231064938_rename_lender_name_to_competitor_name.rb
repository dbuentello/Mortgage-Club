class RenameLenderNameToCompetitorName < ActiveRecord::Migration
  def change
    rename_column :rate_comparisons, :lender_name, :competitor_name
  end
end
