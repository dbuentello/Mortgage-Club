class ChangeOneMoreName < ActiveRecord::Migration
  def change
    rename_column :borrowers, :ages_of_dependents, :dependent_ages
  end
end
