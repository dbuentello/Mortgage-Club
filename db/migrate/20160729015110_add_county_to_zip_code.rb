class AddCountyToZipCode < ActiveRecord::Migration
  def change
    add_column :zip_codes, :county, :string
  end
end
