class FixProperties < ActiveRecord::Migration
  def change
    rename_column :properties, :original_purchase_date, :original_purchase_year
    change_column :properties, :original_purchase_year, 'integer USING EXTRACT(YEAR FROM original_purchase_year)'
  end
end
