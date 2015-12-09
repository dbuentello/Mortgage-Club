class AddYearBuiltToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :year_built, :integer
  end
end
