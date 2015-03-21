class RenameRacesTable < ActiveRecord::Migration
  def change
    rename_table :borrower_race, :borrower_races
  end
end
