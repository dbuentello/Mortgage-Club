class AddDependentCount < ActiveRecord::Migration
  def change
    add_column :borrowers, :dependent_count, :integer
  end
end
