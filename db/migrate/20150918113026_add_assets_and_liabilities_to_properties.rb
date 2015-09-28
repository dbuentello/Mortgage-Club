class AddAssetsAndLiabilitiesToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :estimated_mortgage_insurance, :decimal, :precision => 11, :scale => 2
    add_column :properties, :mortgage_includes_escrows, :integer
    add_column :properties, :hoa_due, :decimal, :precision => 11, :scale => 2
    add_column :properties, :is_primary, :boolean, default: false
  end
end
